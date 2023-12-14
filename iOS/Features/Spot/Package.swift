// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureSpot"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let spot = "Spot"
    
}

private enum Dependency {
    
    // package
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msCoreKit = "MSCoreKit"
    
    // library
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    static let msNetworking = "MSNetworking"
    
    // package = library
    static let msData = "MSData"
    static let msDomain = "MSDomain"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.spot,
                 targets: [Target.spot])
    ],
    dependencies: [
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath),
        .package(name: Dependency.msDomain,
                 path: Dependency.msDomain.fromRootPath)
    ],
    targets: [
        .target(name: Target.spot,
                dependencies: [
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
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
