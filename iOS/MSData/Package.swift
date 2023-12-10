// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    
    static let package = "MSData"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let msData = "MSData"
    static let repository = "Repository"
    
}

private enum Dependency {
    
    static let msDomain = "MSDomain"
    static let msNetworking = "MSNetworking"
    static let msKeychainStorage = "MSKeychainStorage"
    static let msPersistentStorage = "MSPersistentStorage"
    static let msCoreKit = "MSCoreKit"
    static let msLogger = "MSLogger"
    static let msUserDefaults = "MSUserDefaults"
    static let msFoundation = "MSFoundation"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.msData,
                 targets: [Target.msData])
    ],
    dependencies: [
        .package(name: Dependency.msDomain,
                 path: Dependency.msDomain.fromRootPath),
        .package(name: Dependency.msCoreKit,
                 path: Dependency.msCoreKit.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.msData,
                dependencies: [
                    .product(name: Dependency.msDomain,
                             package: Dependency.msDomain),
                    .product(name: Dependency.msNetworking,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msKeychainStorage,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msPersistentStorage,
                             package: Dependency.msCoreKit),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msUserDefaults,
                             package: Dependency.msFoundation)
                ],
                resources: [
                    .process("Resources")
                ]),
        .testTarget(name: Target.msData.testTarget,
                    dependencies: [
                        .target(name: Target.msData)
                    ]),
        .testTarget(name: Target.repository.testTarget,
                    dependencies: [
                        .target(name: Target.msData)
                    ])
    ]
)
