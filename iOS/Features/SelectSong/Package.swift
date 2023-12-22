// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureSelectSong"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let selectSong = "SelectSong"
    
}

private enum Dependency {
    
    static let msDomain = "MSDomain"
    static let msData = "MSData"
    
    static let combineCocoa = "CombineCocoa"
    static let msDesignsystem = "MSDesignSystem"
    static let msUIKit = "MSUIKit"
    
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
        .library(name: Target.selectSong,
                 targets: [Target.selectSong])
    ],
    dependencies: [
        .package(name: Dependency.msDomain,
                 path: Dependency.msDomain.fromRootPath),
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath),
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.selectSong,
                dependencies: [
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
                    .product(name: Dependency.msData,
                             package: Dependency.msData),
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.combineCocoa,
                             package: Dependency.msUIKit),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ]
)
