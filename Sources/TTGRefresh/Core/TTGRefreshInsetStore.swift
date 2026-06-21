import UIKit

@MainActor
final class TTGRefreshInsetStore {
    private var topAddition: CGFloat = 0
    private var bottomAddition: CGFloat = 0

    var currentTopAddition: CGFloat {
        topAddition
    }

    var currentBottomAddition: CGFloat {
        bottomAddition
    }

    func setTopAddition(_ addition: CGFloat, on scrollView: UIScrollView) {
        guard topAddition != addition else { return }
        var inset = scrollView.contentInset
        inset.top = inset.top - topAddition + addition
        topAddition = addition
        scrollView.contentInset = inset
    }

    func setBottomAddition(_ addition: CGFloat, on scrollView: UIScrollView) {
        guard bottomAddition != addition else { return }
        var inset = scrollView.contentInset
        inset.bottom = inset.bottom - bottomAddition + addition
        bottomAddition = addition
        scrollView.contentInset = inset
    }

    func removeAllAdditions(from scrollView: UIScrollView) {
        var inset = scrollView.contentInset
        inset.top -= topAddition
        inset.bottom -= bottomAddition
        topAddition = 0
        bottomAddition = 0
        scrollView.contentInset = inset
    }
}
