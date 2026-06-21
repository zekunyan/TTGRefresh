import UIKit

@MainActor
public protocol TTGRefreshFooterContentView where Self: UIView {
    var preferredHeight: CGFloat { get }
    var triggerHeight: CGFloat { get }
    func refreshFooterDidChange(state: TTGRefreshFooterState)
    func refreshFooterDidUpdate(progress: CGFloat)
}

public extension TTGRefreshFooterContentView {
    var triggerHeight: CGFloat {
        preferredHeight
    }

    func refreshFooterDidUpdate(progress: CGFloat) {}
}
