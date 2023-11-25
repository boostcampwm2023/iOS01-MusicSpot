// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SaveJourney",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "SaveJourney",
                 targets: ["SaveJourney"])
    ],
    dependencies: [
        .package(name: "MSUIKit",
                 path: "../../MSUIKit")
    ],
    targets: [
        .target(name: "SaveJourney",
                dependencies: ["MSUIKit"])
    ]
)
