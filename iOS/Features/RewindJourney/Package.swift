// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureRewindJourney"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let rewindJourney = "RewindJourney"
    
}

private enum Dependency {
    
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    static let msCoreKit = "MSCoreKit"
    static let msData = "MSData"
    static let msNetworking = "MSNetworking"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.rewindJourney,
                 targets: [Target.rewindJourney])
    ],
    dependencies: [
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath)
    ],
    targets: [
        .target(name: Target.rewindJourney,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msDesignsystem,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msNetworking,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msData,
                             package: Dependency.msData)
                ])
    ]
)