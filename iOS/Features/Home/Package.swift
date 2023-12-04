// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureHome"
    
    var fromRootPath: String {
        return "../../" + self
    }
    
    var fromCurrentPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let home = "Home"
    static let navigateMap = "NavigateMap"
    static let recordJourney = "RecordJourney"
    
}

private enum Dependency {
    
    static let journeyList = "JourneyList"
    static let msUIKit = "MSUIKit"
    static let msCoreKit = "MSCoreKit"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.home,
                 targets: [Target.home]),
        .library(name: Target.navigateMap,
                 targets: [Target.navigateMap]),
        .library(name: Target.recordJourney,
                 targets: [Target.recordJourney])
    ],
    dependencies: [
        .package(name: Dependency.journeyList,
                 path: Dependency.journeyList.fromCurrentPath),
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath)
    ],
    targets: [
        .target(name: Target.home,
                dependencies: [
                    .target(name: Target.navigateMap),
                    .product(name: Dependency.journeyList,
                             package: Dependency.journeyList)
                ]),
        .target(name: Target.navigateMap,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit)
                ]),
        .target(name: Target.recordJourney)
    ]
)
