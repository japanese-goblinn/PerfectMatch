// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PerfectMatchDiffing",
    products: [
        .library(name: "PerfectMatchDiffing", targets: ["HeckellsDifference"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections", .branch("main"))
    ],
    targets: [
        .target(
            name: "HeckellsDifference",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ]
        ),
        .testTarget(
            name: "PerfectMatchDiffingTests",
            dependencies: [
                .target(name: "HeckellsDifference")
            ]
        ),
    ]
)
