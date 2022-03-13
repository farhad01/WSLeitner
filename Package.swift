// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WSLeitner",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(
            name: "WSLeitner",
            targets: ["WSLeitner"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WSLeitner",
            dependencies: []),
        .testTarget(
            name: "WSLeitnerTests",
            dependencies: ["WSLeitner"]),
    ]
)
