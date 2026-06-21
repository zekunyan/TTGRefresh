import UIKit

@MainActor
public protocol TTGRefreshHeaderContentView where Self: UIView {
    var preferredHeight: CGFloat { get }
    var triggerHeight: CGFloat { get }
    func refreshHeaderDidChange(state: TTGRefreshHeaderState)
    func refreshHeaderDidUpdate(progress: CGFloat)
}

public extension TTGRefreshHeaderContentView {
    var triggerHeight: CGFloat {
        preferredHeight
    }

    func refreshHeaderDidUpdate(progress: CGFloat) {}
}
