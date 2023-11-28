// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HomeMap",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "HomeMap",
                 targets: ["HomeMap"])
    ],
    targets: [
        .target(name: "HomeMap")
    ]
)
