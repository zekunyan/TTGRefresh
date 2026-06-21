import UIKit

final class DemoNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DemoPalette.background
        navigationBar.tintColor = DemoPalette.accent
        navigationBar.standardAppearance = Self.makeNavigationBarAppearance()
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        navigationBar.compactAppearance = navigationBar.standardAppearance
    }

    private static func makeNavigationBarAppearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DemoPalette.background
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: DemoPalette.text
        ]
        return appearance
    }
}
