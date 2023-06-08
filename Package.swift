// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Dynamo",
    products: [
        .library(
            name: "Dynamo",
            targets: ["Dynamo"]),
    ],
    targets: [
        .target(name: "Dynamo", path: "Sources/"),
        .testTarget(name: "DynamoTests", dependencies: ["Dynamo"]),
    ]
)
