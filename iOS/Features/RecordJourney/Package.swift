// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RecordJourney",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "RecordJourney",
                 targets: ["RecordJourney"])
    ],
    targets: [
        .target(name: "RecordJourney"),
        .testTarget(name: "RecordJourneyTests",
                    dependencies: ["RecordJourney"])
    ]
)
