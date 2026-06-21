import UIKit

struct FeedItem: Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let tag: String
    let tintColor: UIColor
}

struct GalleryItem: Hashable {
    let id = UUID()
    let title: String
    let metric: String
    let symbolName: String
    let tintColor: UIColor
}

enum DemoContentFactory {
    static func feedItems(page: Int, count: Int) -> [FeedItem] {
        (0..<count).map { index in
            let color = DemoPalette.demoColors[(index + page) % DemoPalette.demoColors.count]
            return FeedItem(
                title: "Refresh transaction \(page)-\(index + 1)",
                subtitle: [
                    "Async header action completed without touching the scroll delegate.",
                    "Inset is restored after a short minimum display duration.",
                    "This cell is generated locally so the demo is deterministic.",
                    "Footer loading can continue until the page reports no more data."
                ][index % 4],
                tag: ["Header", "Footer", "Async", "KVO", "Inset"][(index + page) % 5],
                tintColor: color
            )
        }
    }

    static func galleryItems(page: Int, count: Int) -> [GalleryItem] {
        (0..<count).map { index in
            GalleryItem(
                title: ["Low intrusion", "Infinite load", "State machine", "Custom views", "UIKit native"][(index + page) % 5],
                metric: ["0 delegates", "260 pt", "5 states", "100%", "UIKit"][(index + page) % 5],
                symbolName: ["hand.draw", "bolt.fill", "switch.2", "paintpalette.fill", "iphone"][(index + page) % 5],
                tintColor: DemoPalette.demoColors[(index + page) % DemoPalette.demoColors.count]
            )
        }
    }
}
