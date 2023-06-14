// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Dynamo",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "Dynamo",
            targets: ["Dynamo"]
        ),
        .library(
            name: "DynNoise",
            targets: ["DynNoise"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-algorithms.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-async-algorithms.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-collections.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-log.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-metrics.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-numerics.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Dynamo",
            dependencies: [
//                .product(name: "Algorithms", package: "swift-algorithms"),
//                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
//                .product(name: "Collections", package: "swift-collections"),
//                .product(name: "Logging", package: "swift-log"),
//                .product(name: "Markdown", package: "swift-markdown"),
//                .product(name: "Metrics", package: "swift-metrics"),
                .product(name: "Numerics", package: "swift-numerics")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "DynNoise",
            dependencies: [
                .target(name: "Dynamo"),
                .product(name: "Numerics", package: "swift-numerics")
            ],
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(name: "DynamoTests", dependencies: ["DynNoise"]),
    ]
)
