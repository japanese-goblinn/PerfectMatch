// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PerfectMatchDiffing",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(name: "PerfectMatchDiffing", targets: ["PerfectMatchHeckellsDifference"])
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-collections", .branch("main"))
  ],
  targets: [
    .target(
      name: "PerfectMatchHeckellsDifference",
      dependencies: [
        .product(name: "Collections", package: "swift-collections")
      ]
    ),
    .testTarget(
      name: "PerfectMatchDiffingTests",
      dependencies: [
        .target(name: "PerfectMatchHeckellsDifference")
      ]
    ),
  ]
)
