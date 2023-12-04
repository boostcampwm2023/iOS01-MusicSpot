// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    
    static let package = "MSUIKit"
    
    var fromRootPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let msDesignSystem = "MSDesignSystem"
    static let msUIKit = "MSUIKit"
    
}

private enum Dependency {
    
    static let msImageFetcher = "MSImageFetcher"
    static let msCoreKit = "MSCoreKit"
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
        .library(name: Target.msDesignSystem,
                 targets: [Target.msDesignSystem]),
        .library(name: Target.msUIKit,
                 targets: [Target.msUIKit])
    ],
    dependencies: [
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.msDesignSystem,
                resources: [
                    .process("\(Target.msDesignSystem.fromRootPath)/Resources")
                ]),
        .target(name: Target.msUIKit,
                dependencies: [
                    .target(name: Target.msDesignSystem),
                    .product(name: Dependency.msImageFetcher,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ],
    swiftLanguageVersions: [.v5]
)
