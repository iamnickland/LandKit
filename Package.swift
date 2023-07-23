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
            path: "Sources",
            exclude:["Example/"]),
        .testTarget(
            name: "LandKitTests",
            dependencies: ["LandKit"]),
    ],
    swiftLanguageVersions: [
        SwiftVersion.v5,
    ]
)
