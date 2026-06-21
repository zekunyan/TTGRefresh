import UIKit

private enum TTGRefreshAssociatedKeys {
    static var header: UInt8 = 0
    static var footer: UInt8 = 0
    static var insetStore: UInt8 = 0
    static var activityCoordinator: UInt8 = 0
}

@MainActor
public struct TTGRefreshProxy {
    private weak var scrollView: UIScrollView?

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    public var header: TTGRefreshHeader? {
        guard let scrollView else { return nil }
        return TTGAssociatedObject.get(scrollView, key: &TTGRefreshAssociatedKeys.header)
    }

    public var footer: TTGRefreshFooter? {
        guard let scrollView else { return nil }
        return TTGAssociatedObject.get(scrollView, key: &TTGRefreshAssociatedKeys.footer)
    }

    public func addHeaderRefresh(
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addHeaderRefresh(contentView: TTGRefreshDefaultHeaderView(), configuration: configuration, action: action)
    }

    public func addHeaderRefresh(
        contentView: UIView & TTGRefreshHeaderContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        installHeader(
            contentView: contentView,
            configuration: configuration,
            automaticallyEndAfterAction: false
        ) {
            action()
        }
    }

    public func addHeaderRefresh(
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addHeaderRefresh(contentView: TTGRefreshDefaultHeaderView(), configuration: configuration, action: action)
    }

    public func addHeaderRefresh(
        contentView: UIView & TTGRefreshHeaderContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        installHeader(
            contentView: contentView,
            configuration: configuration,
            automaticallyEndAfterAction: configuration.shouldAutoEndAsyncRefreshing,
            action: action
        )
    }

    public func addPathEffectHeaderRefresh(
        style: TTGRefreshPathEffectStyle,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addHeaderRefresh(contentView: TTGRefreshPathEffectHeaderView(style: style), configuration: configuration, action: action)
    }

    public func addPathEffectHeaderRefresh(
        template: TTGRefreshPathEffectTemplate,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addHeaderRefresh(contentView: template.makeHeaderView(), configuration: configuration, action: action)
    }

    public func addPathEffectHeaderRefresh(
        style: TTGRefreshPathEffectStyle,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addHeaderRefresh(contentView: TTGRefreshPathEffectHeaderView(style: style), configuration: configuration, action: action)
    }

    public func addPathEffectHeaderRefresh(
        template: TTGRefreshPathEffectTemplate,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addHeaderRefresh(contentView: template.makeHeaderView(), configuration: configuration, action: action)
    }

    @discardableResult
    public func beginHeaderRefreshing(animated: Bool = true, triggerAction: Bool = true) -> Bool {
        header?.beginRefreshing(animated: animated, triggerAction: triggerAction) ?? false
    }

    @discardableResult
    public func triggerRefresh(animated: Bool = true) -> Bool {
        beginHeaderRefreshing(animated: animated, triggerAction: true)
    }

    public func endHeaderRefreshing(animated: Bool = true) {
        header?.endRefreshing(animated: animated)
    }

    public func removeHeader() {
        guard let scrollView, let header else { return }
        header.detach()
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.header, value: Optional<TTGRefreshHeader>.none)
    }

    public func addFooterRefresh(
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addFooterRefresh(contentView: TTGRefreshDefaultFooterView(), configuration: configuration, action: action)
    }

    public func addFooterRefresh(
        contentView: UIView & TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        installFooter(
            contentView: contentView,
            configuration: configuration,
            mode: .pull,
            automaticallyEndAfterAction: false
        ) {
            action()
        }
    }

    public func addFooterRefresh(
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addFooterRefresh(contentView: TTGRefreshDefaultFooterView(), configuration: configuration, action: action)
    }

    public func addFooterRefresh(
        contentView: UIView & TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        installFooter(
            contentView: contentView,
            configuration: configuration,
            mode: .pull,
            automaticallyEndAfterAction: configuration.shouldAutoEndAsyncRefreshing,
            action: action
        )
    }

    public func addPathEffectFooterRefresh(
        style: TTGRefreshPathEffectStyle,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addFooterRefresh(contentView: TTGRefreshPathEffectFooterView(style: style), configuration: configuration, action: action)
    }

    public func addPathEffectFooterRefresh(
        template: TTGRefreshPathEffectTemplate,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addFooterRefresh(contentView: template.makeFooterView(), configuration: configuration, action: action)
    }

    public func addPathEffectFooterRefresh(
        style: TTGRefreshPathEffectStyle,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addFooterRefresh(contentView: TTGRefreshPathEffectFooterView(style: style), configuration: configuration, action: action)
    }

    public func addPathEffectFooterRefresh(
        template: TTGRefreshPathEffectTemplate,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addFooterRefresh(contentView: template.makeFooterView(), configuration: configuration, action: action)
    }

    public func addInfiniteLoad(
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addInfiniteLoad(preloadOffset: preloadOffset, contentView: TTGRefreshDefaultFooterView(), configuration: configuration, action: action)
    }

    public func addInfiniteLoad(
        preloadOffset: CGFloat = 120,
        contentView: UIView & TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        installFooter(
            contentView: contentView,
            configuration: configuration,
            mode: .infinite(preloadOffset: preloadOffset),
            automaticallyEndAfterAction: false
        ) {
            action()
        }
    }

    public func addInfiniteLoad(
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addInfiniteLoad(preloadOffset: preloadOffset, contentView: TTGRefreshDefaultFooterView(), configuration: configuration, action: action)
    }

    public func addInfiniteLoad(
        preloadOffset: CGFloat = 120,
        contentView: UIView & TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        installFooter(
            contentView: contentView,
            configuration: configuration,
            mode: .infinite(preloadOffset: preloadOffset),
            automaticallyEndAfterAction: configuration.shouldAutoEndAsyncRefreshing,
            action: action
        )
    }

    public func addPathEffectInfiniteLoad(
        style: TTGRefreshPathEffectStyle,
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addInfiniteLoad(
            preloadOffset: preloadOffset,
            contentView: TTGRefreshPathEffectFooterView(style: style),
            configuration: configuration,
            action: action
        )
    }

    public func addPathEffectInfiniteLoad(
        template: TTGRefreshPathEffectTemplate,
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () -> Void
    ) {
        addInfiniteLoad(preloadOffset: preloadOffset, contentView: template.makeFooterView(), configuration: configuration, action: action)
    }

    public func addPathEffectInfiniteLoad(
        style: TTGRefreshPathEffectStyle,
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addInfiniteLoad(
            preloadOffset: preloadOffset,
            contentView: TTGRefreshPathEffectFooterView(style: style),
            configuration: configuration,
            action: action
        )
    }

    public func addPathEffectInfiniteLoad(
        template: TTGRefreshPathEffectTemplate,
        preloadOffset: CGFloat = 120,
        configuration: TTGRefreshConfiguration = .default,
        action: @escaping @MainActor () async -> Void
    ) {
        addInfiniteLoad(preloadOffset: preloadOffset, contentView: template.makeFooterView(), configuration: configuration, action: action)
    }

    @discardableResult
    public func beginFooterRefreshing(animated: Bool = true, triggerAction: Bool = true) -> Bool {
        footer?.beginRefreshing(animated: animated, triggerAction: triggerAction) ?? false
    }

    @discardableResult
    public func triggerLoadMore(animated: Bool = true) -> Bool {
        beginFooterRefreshing(animated: animated, triggerAction: true)
    }

    public func endFooterRefreshing(animated: Bool = true) {
        footer?.endRefreshing(animated: animated)
    }

    public func endFooterRefreshingWithNoMoreData(animated: Bool = true) {
        footer?.endRefreshingWithNoMoreData(animated: animated)
    }

    public func resetFooterNoMoreData() {
        footer?.resetNoMoreData()
    }

    public func removeFooter() {
        guard let scrollView, let footer else { return }
        footer.detach()
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.footer, value: Optional<TTGRefreshFooter>.none)
    }

    public func removeAll() {
        removeHeader()
        removeFooter()
    }

    private func installHeader(
        contentView: UIView & TTGRefreshHeaderContentView,
        configuration: TTGRefreshConfiguration,
        automaticallyEndAfterAction: Bool,
        action: @escaping @MainActor () async -> Void
    ) {
        guard let scrollView else { return }
        removeHeader()
        let header = TTGRefreshHeader(
            contentView: contentView,
            configuration: configuration,
            insetStore: insetStore(for: scrollView),
            activityCoordinator: activityCoordinator(for: scrollView),
            automaticallyEndAfterAction: automaticallyEndAfterAction,
            action: action
        )
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.header, value: header)
        header.attach(to: scrollView)
    }

    private func installFooter(
        contentView: UIView & TTGRefreshFooterContentView,
        configuration: TTGRefreshConfiguration,
        mode: TTGRefreshFooterMode,
        automaticallyEndAfterAction: Bool,
        action: @escaping @MainActor () async -> Void
    ) {
        guard let scrollView else { return }
        removeFooter()
        let footer = TTGRefreshFooter(
            contentView: contentView,
            configuration: configuration,
            mode: mode,
            insetStore: insetStore(for: scrollView),
            activityCoordinator: activityCoordinator(for: scrollView),
            automaticallyEndAfterAction: automaticallyEndAfterAction,
            action: action
        )
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.footer, value: footer)
        footer.attach(to: scrollView)
    }

    private func insetStore(for scrollView: UIScrollView) -> TTGRefreshInsetStore {
        if let store: TTGRefreshInsetStore = TTGAssociatedObject.get(scrollView, key: &TTGRefreshAssociatedKeys.insetStore) {
            return store
        }
        let store = TTGRefreshInsetStore()
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.insetStore, value: store)
        return store
    }

    private func activityCoordinator(for scrollView: UIScrollView) -> TTGRefreshActivityCoordinator {
        if let coordinator: TTGRefreshActivityCoordinator = TTGAssociatedObject.get(
            scrollView,
            key: &TTGRefreshAssociatedKeys.activityCoordinator
        ) {
            return coordinator
        }
        let coordinator = TTGRefreshActivityCoordinator()
        TTGAssociatedObject.set(scrollView, key: &TTGRefreshAssociatedKeys.activityCoordinator, value: coordinator)
        return coordinator
    }
}

@MainActor
public extension UIScrollView {
    var ttg: TTGRefreshProxy {
        TTGRefreshProxy(scrollView: self)
    }
}
