// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PerfectMatchTextEditor",
  platforms: [.macOS(.v11)],
  products: [
    .library(name: "PerfectMatchTextEditor", targets: ["PerfectMatchTextEditor"]),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "PerfectMatchTextEditor",
      dependencies: []
    ),
  ]
)
