// swift-tools-version: 6.0
import PackageDescription

/// Simulates a module you don't control: it's written in Swift 5 language mode,
/// has no isolation annotations, and calls back on a background queue.
let package = Package(
    name: "LegacyArticles",
    products: [
        .library(name: "LegacyArticles", targets: ["LegacyArticles"])
    ],
    targets: [
        .target(
            name: "LegacyArticles",
            swiftSettings: [.swiftLanguageMode(.v5)]
        )
    ]
)
