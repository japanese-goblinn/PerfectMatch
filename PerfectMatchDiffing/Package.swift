// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PerfectMatchDiffing",
    products: [
        .library(name: "PerfectMatchDiffing", targets: ["PerfectMatchDiffing"])
    ],
    dependencies: [],
    targets: [
        .target(name: "PerfectMatchDiffing", dependencies: []),
        
        .testTarget(name: "PerfectMatchDiffingTests", dependencies: ["PerfectMatchDiffing"]),
    ]
)
