// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Dynamo",
    products: [
        .library(
            name: "Dynamo",
            targets: ["Dynamo"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.52.2")),
    ],
    targets: [
        .target(
            name: "Dynamo",
            path: "Sources/",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(name: "DynamoTests", dependencies: ["Dynamo"]),
    ]
)
