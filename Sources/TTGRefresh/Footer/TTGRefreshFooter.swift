import UIKit

@MainActor
public final class TTGRefreshFooter: UIView {
    public private(set) var state: TTGRefreshFooterState = .idle
    public let contentView: any TTGRefreshFooterContentView
    public var configuration: TTGRefreshConfiguration {
        didSet {
            updateTapGestureAvailability()
        }
    }
    public var mode: TTGRefreshFooterMode

    private weak var scrollView: UIScrollView?
    private let insetStore: TTGRefreshInsetStore
    private let activityCoordinator: TTGRefreshActivityCoordinator
    private let action: @MainActor () async -> Void
    private let automaticallyEndAfterAction: Bool
    private var observations: [NSKeyValueObservation] = []
    private var isUpdatingInset = false
    private var refreshingStartDate: Date?
    private var actionTask: Task<Void, Never>?
    private var lastProgress: CGFloat = -1
    private let tapGestureRecognizer = UITapGestureRecognizer()

    init(
        contentView: any TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration,
        mode: TTGRefreshFooterMode,
        insetStore: TTGRefreshInsetStore,
        activityCoordinator: TTGRefreshActivityCoordinator,
        automaticallyEndAfterAction: Bool,
        action: @escaping @MainActor () async -> Void
    ) {
        self.contentView = contentView
        self.configuration = configuration
        self.mode = mode
        self.insetStore = insetStore
        self.activityCoordinator = activityCoordinator
        self.automaticallyEndAfterAction = automaticallyEndAfterAction
        self.action = action
        super.init(frame: .zero)
        clipsToBounds = false
        isUserInteractionEnabled = true
        addSubview(contentView)
        tapGestureRecognizer.addTarget(self, action: #selector(handleTapToLoadMore(_:)))
        addGestureRecognizer(tapGestureRecognizer)
        updateTapGestureAvailability()
        contentView.refreshFooterDidChange(state: .idle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observations.forEach { $0.invalidate() }
        actionTask?.cancel()
    }

    func attach(to scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.addSubview(self)

        observations = [
            scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in self?.handleContentOffsetChange() }
            },
            scrollView.observe(\.contentSize, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in
                    self?.updateFrame()
                    self?.updateVisibility()
                }
            },
            scrollView.observe(\.bounds, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in
                    self?.updateFrame()
                    self?.updateVisibility()
                }
            }
        ]

        updateFrame()
        updateVisibility()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    @discardableResult
    public func beginRefreshing(animated: Bool = true, triggerAction: Bool = true) -> Bool {
        guard state != .loading, state != .noMoreData, state != .hidden else { return false }
        guard activityCoordinator.begin(.footer) else { return false }
        if configuration.automaticallyChangeAlpha {
            alpha = 1
        }
        refreshingStartDate = Date()
        applyProgress(1)
        applyState(.loading)
        emitHapticFeedbackIfNeeded()
        setFooterVisible(true, animated: animated) { [weak self] in
            guard let self else { return }
            if triggerAction {
                self.performAction()
            }
        }
        return true
    }

    public func endRefreshing(animated: Bool = true) {
        guard state != .idle, state != .noMoreData else {
            return
        }

        if state == .hidden {
            refreshingStartDate = nil
            applyProgress(0)
            activityCoordinator.end(.footer)
            return
        }

        let elapsed = refreshingStartDate.map { Date().timeIntervalSince($0) } ?? configuration.minimumRefreshingDuration
        let delay = max(0, configuration.minimumRefreshingDuration - elapsed)

        Task { @MainActor [weak self] in
            if delay > 0 {
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            self?.finishEnding(animated: animated)
        }
    }

    public func endRefreshingWithNoMoreData(animated: Bool = true) {
        guard state != .hidden else { return }
        refreshingStartDate = nil
        setFooterVisible(false, animated: animated) { [weak self] in
            guard let self else { return }
            self.activityCoordinator.end(.footer)
            self.applyState(.noMoreData)
            self.updateVisibility()
        }
    }

    public func resetNoMoreData() {
        guard state == .noMoreData || state == .hidden else { return }
        applyState(.idle)
        updateVisibility()
    }

    @objc private func handleTapToLoadMore(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.state == .ended else { return }
        guard configuration.isTapToLoadMoreEnabled else { return }
        guard !isHidden, state != .loading, state != .noMoreData, state != .hidden else { return }
        beginRefreshing()
    }

    func detach() {
        observations.forEach { $0.invalidate() }
        observations.removeAll()
        actionTask?.cancel()
        activityCoordinator.end(.footer)
        if let scrollView {
            insetStore.setBottomAddition(0, on: scrollView)
        }
        removeFromSuperview()
    }

    private func updateFrame() {
        guard let scrollView else { return }
        let height = contentView.preferredHeight
        let y = max(scrollView.contentSize.height, visibleContentHeight(in: scrollView))
        frame = CGRect(x: 0, y: y, width: scrollView.bounds.width, height: height)
        setNeedsLayout()
    }

    private func updateVisibility() {
        guard let scrollView else { return }

        let contentFits = scrollView.contentSize.height <= visibleContentHeight(in: scrollView)
        let shouldHideForMode: Bool

        switch configuration.footerVisibilityMode {
        case .automatic:
            shouldHideForMode = false
        case .always:
            shouldHideForMode = false
        case .hiddenWhenContentFits:
            shouldHideForMode = contentFits
        case .hiddenWhenNoMoreData:
            shouldHideForMode = state == .noMoreData
        }

        let shouldHide = state == .loading ? false : shouldHideForMode
        isHidden = shouldHide
        if shouldHide {
            insetStore.setBottomAddition(0, on: scrollView)
            applyState(.hidden)
        } else if state == .hidden {
            applyState(.idle)
        }

        updateRestingInset()
        updateTapGestureAvailability()
    }

    private func handleContentOffsetChange() {
        guard let scrollView, !isUpdatingInset, !isHidden else { return }
        guard state != .loading, state != .noMoreData else { return }

        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = scrollView.contentOffset.y
            + scrollView.bounds.height
            - scrollView.adjustedContentInset.bottom
            - contentHeight

        switch mode {
        case .infinite(let preloadOffset):
            guard contentHeight > 0 else { return }
            if distanceFromBottom >= -preloadOffset, activityCoordinator.canBegin(.footer) {
                beginRefreshing()
            }
        case .pull:
            let pullDistance = max(0, distanceFromBottom)
            let triggerHeight = max(contentView.triggerHeight, 1)
            let progress = min(pullDistance / triggerHeight, 1)
            applyProgress(progress)

            if configuration.automaticallyChangeAlpha {
                alpha = pullDistance > 0 ? max(progress, 0.35) : 1
            }

            if scrollView.isDragging {
                if pullDistance >= triggerHeight, activityCoordinator.canBegin(.footer) {
                    applyState(.willLoad)
                } else if pullDistance > 0 {
                    applyState(.pulling(progress: progress))
                } else {
                    applyState(.idle)
                }
                return
            }

            if state == .willLoad {
                if !beginRefreshing() {
                    applyProgress(0)
                    applyState(.idle)
                }
            } else if pullDistance > 0 {
                applyState(.pulling(progress: progress))
            } else {
                applyState(.idle)
            }
        }
    }

    private func performAction() {
        actionTask?.cancel()
        actionTask = Task { @MainActor [weak self] in
            guard let self else { return }
            await self.action()
            if self.automaticallyEndAfterAction {
                self.endRefreshing()
            }
        }
    }

    private func finishEnding(animated: Bool) {
        setFooterVisible(false, animated: animated) { [weak self] in
            guard let self else { return }
            self.refreshingStartDate = nil
            self.applyProgress(0)
            self.applyState(.idle)
            self.updateFrame()
            self.updateVisibility()
            self.activityCoordinator.end(.footer)
        }
    }

    private func setFooterVisible(_ visible: Bool, animated: Bool, completion: @escaping () -> Void) {
        guard let scrollView else {
            completion()
            return
        }

        let height = visible ? contentView.preferredHeight : restingFooterHeight()
        isUpdatingInset = true

        let updates = {
            self.insetStore.setBottomAddition(height, on: scrollView)
        }

        let finish = {
            self.isUpdatingInset = false
            if self.configuration.automaticallyChangeAlpha {
                self.alpha = 1
            }
            completion()
        }

        if animated {
            UIView.animate(withDuration: configuration.animationDuration, animations: updates) { _ in
                finish()
            }
        } else {
            updates()
            finish()
        }
    }

    private func visibleContentHeight(in scrollView: UIScrollView) -> CGFloat {
        max(0, scrollView.bounds.height - scrollView.adjustedContentInset.top - scrollView.adjustedContentInset.bottom)
    }

    private func updateRestingInset() {
        guard let scrollView, !isUpdatingInset, state != .loading else { return }
        insetStore.setBottomAddition(restingFooterHeight(), on: scrollView)
    }

    private func restingFooterHeight() -> CGFloat {
        guard !isHidden else { return 0 }

        switch mode {
        case .pull:
            if state == .noMoreData, configuration.footerVisibilityMode == .hiddenWhenNoMoreData {
                return 0
            }
            return contentView.preferredHeight
        case .infinite:
            return 0
        }
    }

    private func applyState(_ newState: TTGRefreshFooterState) {
        guard state != newState else { return }
        state = newState
        updateTapGestureAvailability()
        contentView.refreshFooterDidChange(state: newState)
    }

    private func updateTapGestureAvailability() {
        tapGestureRecognizer.isEnabled = configuration.isTapToLoadMoreEnabled
            && !isHidden
            && state != .loading
            && state != .noMoreData
            && state != .hidden
    }

    private func applyProgress(_ progress: CGFloat) {
        guard abs(progress - lastProgress) >= 0.005 else { return }
        lastProgress = progress
        contentView.refreshFooterDidUpdate(progress: progress)
    }

    private func emitHapticFeedbackIfNeeded() {
        guard configuration.hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
