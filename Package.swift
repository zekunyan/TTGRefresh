// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "TTGRefresh",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "TTGRefresh",
            targets: ["TTGRefresh"]
        )
    ],
    targets: [
        .target(
            name: "TTGRefresh",
            path: "Sources/TTGRefresh"
        ),
        .testTarget(
            name: "TTGRefreshTests",
            dependencies: ["TTGRefresh"],
            path: "Tests/TTGRefreshTests"
        )
    ]
)
