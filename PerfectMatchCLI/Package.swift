// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PerfectMatchCLI",
  platforms: [.macOS(.v11)],
  products: [
    .executable(name: "perfect-match", targets: ["PerfectMatchCLI"])
  ],
  dependencies: [
    .package(url: "git@github.com:apple/swift-argument-parser.git", .branch("main"))
  ],
  targets: [
    .target(
      name: "PerfectMatchCLI",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
    .testTarget(
      name: "PerfectMatchCLITests",
      dependencies: ["PerfectMatchCLI"]
    ),
  ]
)
