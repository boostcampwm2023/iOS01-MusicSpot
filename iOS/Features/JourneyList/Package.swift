// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureJourneyList"

	var fromRootPath: String {
        return "../../" + self
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let journeyList = "JourneyList"
    
}

private enum Dependency {
    
    static let msUIKit = "MSUIKit"
    static let msCacheStorage = "MSCacheStorage"
    static let msCoreKit = "MSCoreKit"
    static let msData = "MSData"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.journeyList,
                 targets: [Target.journeyList])
    ],
    dependencies: [
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath)
    ],
    targets: [
        .target(name: Target.journeyList,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msCacheStorage,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msData,
                             package: Dependency.msData)
                ])
    ]
)
