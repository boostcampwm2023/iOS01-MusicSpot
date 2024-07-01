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
    static let msData = "MSData"
    static let msDomain = "MSDomain"
    
    static let msUIKit = "MSUIKit"
    static let msFusion = "MSFusion"
    
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
        .library(name: Target.spot,
                 targets: [Target.spot])
    ],
    dependencies: [
        .package(name: Dependency.msDomain,
                 path: Dependency.msDomain.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath),
        .package(name: Dependency.msFusion,
                 path: Dependency.msFusion.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.spot,
                dependencies: [
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
                    .product(name: Dependency.msData,
                             package: Dependency.msData),
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msFusion),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ]
)