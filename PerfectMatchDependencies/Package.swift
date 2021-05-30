// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "PerfectMatchDependencies",
  platforms: [.macOS(.v11)],
  products: [
    .library(name: "PerfectMatchDependencies", targets: ["PerfectMatchDependencies"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "PerfectMatchDependencies",
      dependencies: []
    ),
  ]
)
