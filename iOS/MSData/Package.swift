// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MSData",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MSData",
                 targets: ["MSData"])
    ],
    dependencies: [
        .package(name: "MSNetworking",
                 path: "../MSCoreKit")
    ],
    targets: [
        .target(name: "MSData",
                dependencies: ["MSNetworking"],
                resources: [.process("../../Resources/APIInfo.plist")]),
        .testTarget(name: "MSDataTests",
                    dependencies: ["MSData"])
    ]
)
