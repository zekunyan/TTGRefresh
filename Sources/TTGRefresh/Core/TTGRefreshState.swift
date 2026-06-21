import UIKit

public enum TTGRefreshHeaderState: Equatable {
    case idle
    case pulling(progress: CGFloat)
    case willRefresh
    case refreshing
    case ending
}

public enum TTGRefreshFooterState: Equatable {
    case idle
    case pulling(progress: CGFloat)
    case willLoad
    case loading
    case noMoreData
    case hidden
}

public enum TTGRefreshFooterMode: Equatable {
    case pull
    case infinite(preloadOffset: CGFloat)
}

public enum TTGRefreshHeaderPresentationMode: Equatable {
    case contentInset
    case overlay
}

public enum TTGRefreshFooterVisibilityMode: Equatable {
    case automatic
    case always
    case hiddenWhenContentFits
    case hiddenWhenNoMoreData
}
