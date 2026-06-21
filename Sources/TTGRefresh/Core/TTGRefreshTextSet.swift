import Foundation

public struct TTGRefreshHeaderTextSet: Equatable {
    public var idle: String
    public var pulling: String
    public var willRefresh: String
    public var refreshing: String
    public var ending: String

    public init(
        idle: String = "Pull to refresh",
        pulling: String = "Pull to refresh",
        willRefresh: String = "Release to refresh",
        refreshing: String = "Refreshing...",
        ending: String = "Refreshing..."
    ) {
        self.idle = idle
        self.pulling = pulling
        self.willRefresh = willRefresh
        self.refreshing = refreshing
        self.ending = ending
    }

    public static let `default` = TTGRefreshHeaderTextSet()
}

public struct TTGRefreshFooterTextSet: Equatable {
    public var idle: String
    public var pulling: String
    public var willLoad: String
    public var loading: String
    public var noMoreData: String

    public init(
        idle: String = "Pull up or tap to load more",
        pulling: String = "Pull up or tap to load more",
        willLoad: String = "Release to load more",
        loading: String = "Loading...",
        noMoreData: String = "No more data"
    ) {
        self.idle = idle
        self.pulling = pulling
        self.willLoad = willLoad
        self.loading = loading
        self.noMoreData = noMoreData
    }

    public static let `default` = TTGRefreshFooterTextSet()
}
