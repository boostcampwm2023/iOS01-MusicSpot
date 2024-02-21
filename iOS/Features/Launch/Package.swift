// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureLaunch"
    
    var fromRootPath: String {
        return "../../" + self
    }
    
    var fromCurrentPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let version = "Version"
    static let splash = "Splash"
    
}

private enum Dependency {
    
    static let msSwiftUI = "MSSwiftUI"
    static let msUIKit = "MSUIKit"
    static let msFusion = "MSFusion"
    
    static let versionManager = "VersionManager"
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
        .library(name: Target.splash,
                 targets: [Target.splash]),
        .library(name: Target.version,
                 targets: [Target.version])
    ],
    dependencies: [
        .package(name: Dependency.msFusion,
                 path: Dependency.msFusion.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.splash,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msFusion),
                    .product(name: Dependency.versionManager,
                             package: Dependency.msCoreKit)
                ],
                resources: [
                    .process("../\(Target.splash)/Resources")
                ]),
        .target(name: Target.version,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msFusion),
                    .product(name: Dependency.msSwiftUI,
                             package: Dependency.msFusion),
                    .product(name: Dependency.versionManager,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msUserDefaults,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ]
)

