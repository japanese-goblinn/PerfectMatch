// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PerfectMatchUI",
  platforms: [
    .macOS(.v11)
  ],
  products: [
    .library(name: "PerfectMatchUI", targets: ["PerfectMatchUI"]),
  ],
  dependencies: [
    .package(name: "PerfectMatchResources", path: "../PerfectMatchResources"),
    .package(name: "PerfectMatchDiffing", path: "../PerfectMatchDiffing"),
    .package(name: "PerfectMatchTextEditor", path: "../PerfectMatchTextEditor"),
    
    .package(name: "PerfectMatchDependencies", path: "../PerfectMatchDependencies")
  ],
  targets: [
    .target(
      name: "PerfectMatchUI",
      dependencies: [
        .product(name: "PerfectMatchDiffing", package: "PerfectMatchDiffing"),
        .product(name: "PerfectMatchResources", package: "PerfectMatchResources"),
        .product(name: "PerfectMatchTextEditor", package: "PerfectMatchTextEditor"),
        
        .product(name: "PerfectMatchDependencies", package: "PerfectMatchDependencies")
      ]
    )
  ]
)
