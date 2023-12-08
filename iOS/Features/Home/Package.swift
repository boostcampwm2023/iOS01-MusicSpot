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
    
}

private enum Dependency {
    
    static let journeyList = "JourneyList"
    static let msDomain = "MSDomain"
    static let msData = "MSData"
    static let msUIKit = "MSUIKit"
    static let msKeychainStorage = "MSKeychainStorage"
    static let msCoreKit = "MSCoreKit"
    static let msUserDefaults = "MSUserDefaults"
    static let msLogger = "MSLogger"
    static let msFoundation = "MSFoundation"
    
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
                 targets: [Target.navigateMap])
    ],
    dependencies: [
        .package(name: Dependency.journeyList,
                 path: Dependency.journeyList.fromCurrentPath),
        .package(name: Dependency.msDomain,
                 path: Dependency.msDomain.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath),
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.home,
                dependencies: [
                    .product(name: Dependency.journeyList,
                             package: Dependency.journeyList),
                    .target(name: Target.navigateMap),
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
                    .product(name: Dependency.msData,
                             package: Dependency.msData),
                    .product(name: Dependency.msKeychainStorage,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msUserDefaults,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.navigateMap,
                dependencies: [
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
                    .product(name: Dependency.msData,
                             package: Dependency.msData),
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msUserDefaults,
                             package: Dependency.msFoundation),
                ]),
    ]
)
