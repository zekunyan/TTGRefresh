import UIKit

public struct TTGRefreshConfiguration {
    public var animationDuration: TimeInterval
    public var minimumRefreshingDuration: TimeInterval
    public var automaticallyChangeAlpha: Bool
    public var minimumVisibleAlpha: CGFloat
    public var headerContentVerticalOffset: CGFloat
    public var hapticsEnabled: Bool
    public var headerPresentationMode: TTGRefreshHeaderPresentationMode
    public var footerVisibilityMode: TTGRefreshFooterVisibilityMode
    public var shouldAutoEndAsyncRefreshing: Bool
    public var isTapToLoadMoreEnabled: Bool

    public init(
        animationDuration: TimeInterval = 0.25,
        minimumRefreshingDuration: TimeInterval = 0.25,
        automaticallyChangeAlpha: Bool = false,
        minimumVisibleAlpha: CGFloat = 0.24,
        headerContentVerticalOffset: CGFloat = 36,
        hapticsEnabled: Bool = false,
        headerPresentationMode: TTGRefreshHeaderPresentationMode = .contentInset,
        footerVisibilityMode: TTGRefreshFooterVisibilityMode = .automatic,
        shouldAutoEndAsyncRefreshing: Bool = true,
        isTapToLoadMoreEnabled: Bool = true
    ) {
        self.animationDuration = animationDuration
        self.minimumRefreshingDuration = minimumRefreshingDuration
        self.automaticallyChangeAlpha = automaticallyChangeAlpha
        self.minimumVisibleAlpha = minimumVisibleAlpha
        self.headerContentVerticalOffset = headerContentVerticalOffset
        self.hapticsEnabled = hapticsEnabled
        self.headerPresentationMode = headerPresentationMode
        self.footerVisibilityMode = footerVisibilityMode
        self.shouldAutoEndAsyncRefreshing = shouldAutoEndAsyncRefreshing
        self.isTapToLoadMoreEnabled = isTapToLoadMoreEnabled
    }

    public static var `default` = TTGRefreshConfiguration()
}
