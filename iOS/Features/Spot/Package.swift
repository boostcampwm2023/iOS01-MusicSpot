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
    
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    
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
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.spot,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msDesignsystem,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ]
)
