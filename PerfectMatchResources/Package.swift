// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PerfectMatchResources",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(name: "PerfectMatchResources", targets: ["PerfectMatchResources"])
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "PerfectMatchResources",
      dependencies: []
    )
  ]
)
