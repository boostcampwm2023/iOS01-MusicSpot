// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JourneyList",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "JourneyList",
            targets: ["JourneyList"])
    ],
    dependencies: [
        .package(name: "MSUIKit", path: "../../MSUIKit")
    ],
    targets: [
        .target(
            name: "JourneyList",
            dependencies: ["MSUIKit"])
    ]
)
