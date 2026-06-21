import UIKit

@MainActor
public final class TTGRefreshHeader: UIView {
    public private(set) var state: TTGRefreshHeaderState = .idle
    public let contentView: any TTGRefreshHeaderContentView
    public var configuration: TTGRefreshConfiguration

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
    private var visibilityAnimator: UIViewPropertyAnimator?
    private var overlayPullStartTranslationY: CGFloat?
    private var isHoldingOverlayContent = false

    init(
        contentView: any TTGRefreshHeaderContentView,
        configuration: TTGRefreshConfiguration,
        insetStore: TTGRefreshInsetStore,
        activityCoordinator: TTGRefreshActivityCoordinator,
        automaticallyEndAfterAction: Bool,
        action: @escaping @MainActor () async -> Void
    ) {
        self.contentView = contentView
        self.configuration = configuration
        self.insetStore = insetStore
        self.activityCoordinator = activityCoordinator
        self.automaticallyEndAfterAction = automaticallyEndAfterAction
        self.action = action
        super.init(frame: .zero)
        clipsToBounds = false
        isHidden = true
        alpha = 0
        addSubview(contentView)
        contentView.refreshHeaderDidChange(state: .idle)
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
        switch configuration.headerPresentationMode {
        case .contentInset:
            scrollView.insertSubview(self, at: 0)
        case .overlay:
            scrollView.addSubview(self)
        }

        observations = [
            scrollView.observe(\.contentOffset, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in self?.handleContentOffsetChange() }
            },
            scrollView.observe(\.contentSize, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in self?.updateFrame() }
            },
            scrollView.observe(\.bounds, options: [.new]) { [weak self] _, _ in
                Task { @MainActor in self?.updateFrame() }
            }
        ]
        scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePanGesture(_:)))

        updateFrame()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateContentFrame()
    }

    @discardableResult
    public func beginRefreshing(animated: Bool = true, triggerAction: Bool = true) -> Bool {
        guard state != .refreshing, state != .ending else { return false }
        guard activityCoordinator.begin(.header) else { return false }
        setContentHidden(false, animated: animated)
        if configuration.automaticallyChangeAlpha {
            alpha = 1
        }
        refreshingStartDate = Date()
        applyProgress(1)
        applyState(.refreshing)
        emitHapticFeedbackIfNeeded()
        setHeaderVisible(true, animated: animated) { [weak self] in
            guard let self else { return }
            if triggerAction {
                self.performAction()
            }
        }
        return true
    }

    public func endRefreshing(animated: Bool = true) {
        guard state != .idle, state != .ending else {
            if state != .idle {
                applyState(.idle)
            }
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

    func detach() {
        observations.forEach { $0.invalidate() }
        observations.removeAll()
        actionTask?.cancel()
        scrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handlePanGesture(_:)))
        activityCoordinator.end(.header)
        if let scrollView {
            insetStore.setTopAddition(0, on: scrollView)
        }
        removeFromSuperview()
    }

    private func updateFrame() {
        guard let scrollView else { return }
        let height = contentView.preferredHeight
        let y: CGFloat
        switch configuration.headerPresentationMode {
        case .contentInset:
            y = -height
        case .overlay:
            y = scrollView.contentOffset.y + scrollView.adjustedContentInset.top
            scrollView.bringSubviewToFront(self)
        }
        frame = CGRect(x: 0, y: y, width: scrollView.bounds.width, height: height)
        setNeedsLayout()
    }

    @objc private func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard configuration.headerPresentationMode == .overlay else { return }
        handleContentOffsetChange()
    }

    private func handleContentOffsetChange() {
        guard let scrollView, !isUpdatingInset, !isHoldingOverlayContent else { return }
        updateFrame()
        guard state != .refreshing, state != .ending else { return }

        holdOverlayContentIfNeeded(in: scrollView)

        let triggerHeight = max(contentView.triggerHeight, 1)
        let pullDistance = currentPullDistance(in: scrollView)
        let shouldRefreshAfterRelease = !scrollView.isDragging && (state == .willRefresh || pullDistance >= triggerHeight)
        let progress = shouldRefreshAfterRelease ? 1 : min(pullDistance / triggerHeight, 1)
        let canBeginRefresh = activityCoordinator.canBegin(.header)
        applyHeaderPresentation(progress: progress)

        setContentHidden(
            pullDistance <= 0 && state == .idle,
            animated: !configuration.automaticallyChangeAlpha
        )
        applyProgress(progress)

        if configuration.automaticallyChangeAlpha {
            alpha = pullDistance > 0 ? max(progress, configuration.minimumVisibleAlpha) : 0
        }

        if scrollView.isDragging {
            if pullDistance >= triggerHeight, canBeginRefresh {
                applyState(.willRefresh)
            } else if pullDistance > 0 {
                applyState(.pulling(progress: progress))
            } else {
                applyState(.idle)
            }
            return
        }

        if shouldRefreshAfterRelease {
            if !beginRefreshing() {
                applyHeaderPresentation(progress: 0)
                applyProgress(0)
                applyState(.idle)
                setContentHidden(true)
            }
        } else if pullDistance > 0 {
            applyState(.pulling(progress: progress))
        } else {
            applyState(.idle)
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
        guard state != .idle else { return }
        applyState(.ending)
        setHeaderVisible(false, animated: animated) { [weak self] in
            guard let self else { return }
            self.refreshingStartDate = nil
            self.applyProgress(0)
            self.applyState(.idle)
            self.setContentHidden(true)
            self.activityCoordinator.end(.header)
        }
    }

    private func setHeaderVisible(_ visible: Bool, animated: Bool, completion: @escaping () -> Void) {
        guard let scrollView else {
            completion()
            return
        }

        let height = visible ? contentView.preferredHeight : 0
        isUpdatingInset = true
        if visible {
            setContentHidden(false, animated: animated)
        }
        let isOverlayMode = configuration.headerPresentationMode == .overlay

        let updates = {
            switch self.configuration.headerPresentationMode {
            case .contentInset:
                self.insetStore.setTopAddition(height, on: scrollView)
                if visible {
                    var offset = scrollView.contentOffset
                    offset.y = -scrollView.adjustedContentInset.top
                    scrollView.setContentOffset(offset, animated: false)
                }
            case .overlay:
                self.updateFrame()
                self.applyHeaderPresentation(progress: 1)
                if !visible {
                    self.alpha = 0
                }
            }
        }

        let finish = {
            self.isUpdatingInset = false
            if isOverlayMode, !visible {
                self.isHidden = true
                self.alpha = 0
                self.applyHeaderPresentation(progress: 0)
            } else if self.configuration.automaticallyChangeAlpha {
                self.alpha = visible ? 1 : 0
            }
            if !visible, !isOverlayMode {
                self.setContentHidden(true)
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

    private func applyState(_ newState: TTGRefreshHeaderState) {
        guard state != newState else { return }
        state = newState
        if newState == .idle, lastProgress <= 0, insetStore.currentTopAddition <= 0 {
            setContentHidden(true)
        } else {
            setContentHidden(false)
        }
        contentView.refreshHeaderDidChange(state: newState)
        updateContentFrame()
    }

    private func updateContentFrame() {
        let verticalOffset: CGFloat
        switch state {
        case .refreshing, .ending:
            verticalOffset = 0
        case .idle, .pulling, .willRefresh:
            let progress = min(max(lastProgress, 0), 1)
            verticalOffset = configuration.headerContentVerticalOffset * (1 - progress)
        }

        contentView.frame = CGRect(
            x: 0,
            y: verticalOffset,
            width: bounds.width,
            height: max(0, bounds.height - verticalOffset)
        )
    }

    private func currentPullDistance(in scrollView: UIScrollView) -> CGFloat {
        switch configuration.headerPresentationMode {
        case .contentInset:
            return max(0, -(scrollView.contentOffset.y + scrollView.adjustedContentInset.top))
        case .overlay:
            let gesture = scrollView.panGestureRecognizer
            let isActivePull = gesture.state == .began || gesture.state == .changed
            let isAtTop = scrollView.contentOffset.y <= -scrollView.adjustedContentInset.top + 0.5
            let translationY = gesture.translation(in: scrollView).y

            guard isActivePull, isAtTop, translationY > 0 else {
                overlayPullStartTranslationY = nil
                return 0
            }

            if overlayPullStartTranslationY == nil {
                overlayPullStartTranslationY = max(0, translationY - 1)
            }

            return max(0, translationY - (overlayPullStartTranslationY ?? 0))
        }
    }

    private func holdOverlayContentIfNeeded(in scrollView: UIScrollView) {
        guard configuration.headerPresentationMode == .overlay else { return }
        let gesture = scrollView.panGestureRecognizer
        let isActivePull = gesture.state == .began || gesture.state == .changed
        guard isActivePull, gesture.translation(in: scrollView).y > 0 else { return }

        let topOffset = -scrollView.adjustedContentInset.top
        guard scrollView.contentOffset.y < topOffset else { return }

        isHoldingOverlayContent = true
        var offset = scrollView.contentOffset
        offset.y = topOffset
        scrollView.setContentOffset(offset, animated: false)
        isHoldingOverlayContent = false
        updateFrame()
    }

    private func applyHeaderPresentation(progress: CGFloat) {
        guard configuration.headerPresentationMode == .overlay else { return }
        let clampedProgress = min(max(progress, 0), 1)
        contentView.transform = CGAffineTransform(
            translationX: 0,
            y: -contentView.preferredHeight * (1 - clampedProgress)
        )
    }

    private func applyProgress(_ progress: CGFloat) {
        guard abs(progress - lastProgress) >= 0.005 else { return }
        lastProgress = progress
        updateContentFrame()
        contentView.refreshHeaderDidUpdate(progress: progress)
    }

    private func setContentHidden(_ hidden: Bool, animated: Bool = true) {
        if hidden {
            guard !isHidden || alpha > 0 else { return }
            visibilityAnimator?.stopAnimation(true)

            let hide = {
                self.alpha = 0
            }
            let complete = {
                self.isHidden = true
            }

            if animated, configuration.animationDuration > 0, alpha > 0 {
                let animator = UIViewPropertyAnimator(duration: min(0.18, configuration.animationDuration), curve: .easeOut) {
                    hide()
                }
                animator.addCompletion { [weak self] _ in
                    self?.visibilityAnimator = nil
                    complete()
                }
                visibilityAnimator = animator
                animator.startAnimation()
            } else {
                hide()
                complete()
            }
            return
        }

        let shouldShow = isHidden || (!configuration.automaticallyChangeAlpha && alpha < 1)
        guard shouldShow else { return }
        visibilityAnimator?.stopAnimation(true)
        isHidden = false

        if configuration.automaticallyChangeAlpha {
            return
        }

        let show = {
            self.alpha = 1
        }

        if animated, configuration.animationDuration > 0 {
            let animator = UIViewPropertyAnimator(duration: min(0.14, configuration.animationDuration), curve: .easeOut) {
                show()
            }
            animator.addCompletion { [weak self] _ in
                self?.visibilityAnimator = nil
            }
            visibilityAnimator = animator
            animator.startAnimation()
        } else {
            show()
        }
    }

    private func emitHapticFeedbackIfNeeded() {
        guard configuration.hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
