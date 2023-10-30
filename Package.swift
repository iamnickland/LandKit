// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LandKit",
    platforms: [.iOS("13.0")],
    products: [
        .library(
            name: "LandKit",
            targets: ["LandKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LandKit",
            path: "Sources"),
        .testTarget(
            name: "LandKitTests",
            dependencies: ["LandKit"]),
        .binaryTarget(name: "Queuer", path: "Queuer.xcframework")
    ],
    swiftLanguageVersions: [
        SwiftVersion.v5,
    ]
)
