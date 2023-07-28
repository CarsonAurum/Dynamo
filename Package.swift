// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

// MARK: Package

let supportedPlatforms: [SupportedPlatform] = [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6)
]

// MARK: Libraries

let deliverables: [Product] = [
    .library(
        name: "Dynamo",
        targets: ["Dynamo"]
    ),
    .library(
        name: "DynNoise",
        targets: ["DynNoise"]
    ),
    .library(name: "DynMacros", targets: ["DynMacros"]),
    .library(name: "DynState", targets: ["DynState"])
]

// MARK: Targets

let mainTargets: [Target] = [
    .target(
        name: "Dynamo",
        dependencies: [
//                .product(name: "Algorithms ", package: "swift-algorithms"),
//                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
            .product(name: "Atomics", package: "swift-atomics"),
//                .product(name: "Collections", package: "swift-collections"),
            .product(name: "Logging", package: "swift-log"),
//                .product(name: "Markdown", package: "swift-markdown"),
//                .product(name: "Metrics", package: "swift-metrics"),
            .product(name: "Numerics", package: "swift-numerics")
        ],
        plugins: [
//            .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
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
    .target(
        name: "DynState",
        dependencies: [
            .target(name: "Dynamo"),
            .product(name: "Numerics", package: "swift-numerics")
        ],
        plugins: [
            .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
        ]
    )
]

let macros: [Target] = [
    .macro(
        name: "MacroImplementations",
        dependencies: [
            .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            .product(name: "SwiftSyntax", package: "swift-syntax"),
        ],
        path: "Macros"
    ),
    .target(name: "DynMacros", dependencies: ["MacroImplementations"]),
]

let tests: [Target] = [
    .testTarget(name: "DynamoTests", dependencies: ["DynNoise"]),
]

// MARK: Dependencies

let depends: [Package.Dependency] = [
    .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-algorithms.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-async-algorithms.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-atomics.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-collections.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-log.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
//        .package(url: "https://github.com/apple/swift-metrics.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-numerics.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-syntax.git", branch: "main")
]

let package = Package(
    name: "Dynamo",
    platforms: supportedPlatforms,
    products: deliverables,
    dependencies: depends,
    targets: mainTargets + macros + tests
)
