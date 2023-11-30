// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureHome"
    
}

private enum Target {
    
    static let navigateMap = "NavigateMap"
    static let recordJourney = "RecordJourney"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.navigateMap,
                 targets: [Target.navigateMap]),
        .library(name: Target.recordJourney,
                 targets: [Target.recordJourney])
    ],
    targets: [
        .target(name: Target.navigateMap),
        .target(name: Target.recordJourney)
    ]
)
