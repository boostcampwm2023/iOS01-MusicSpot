// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SelectSong",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "SelectSong",
                 targets: ["SelectSong"])
    ],
    targets: [
        .target(name: "SelectSong")
    ]
)
