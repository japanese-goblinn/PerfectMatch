// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PerfectMatchDependencies",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(name: "PerfectMatchDependencies_Sourceful", targets: ["PerfectMatchDependencies_Sourceful"])
  ],
  dependencies: [
    .package(url: "git@github.com:twostraws/Sourceful.git", .branch("main")),
  ],
  targets: [
    .target(
      name: "PerfectMatchDependencies_Sourceful",
      dependencies: [
        .product(name: "Sourceful", package: "Sourceful")
      ],
      path: "Sources/Sourceful"
    ),
  ]
)
