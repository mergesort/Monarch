// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Monarch",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Monarch",
            targets: ["Monarch"]
        ),
    ],
    targets: [
        .target(
            name: "Monarch"
        ),
        .testTarget(
            name: "MonarchTests",
            dependencies: ["Monarch"]
        ),
    ]
)
