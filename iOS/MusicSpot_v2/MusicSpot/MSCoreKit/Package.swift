// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "MSCoreKit"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let msImageFetcher = "MSImageFetcher"
    static let msPersistentStorage = "MSPersistentStorage"
    static let msNetworking = "MSNetworking"
    static let msCacheStorage = "MSCacheStorage"
    static let msKeychainStorage = "MSKeychainStorage"
    static let stateStore = "StateStore"
    static let versionManager = "VersionManager"
    
}

private enum Dependency {
    
    static let msConstants = "MSConstants"
    static let msLogger = "MSLogger"
    static let msFoundation = "MSFoundation"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: Target.msImageFetcher,
                 targets: [Target.msImageFetcher]),
        .library(name: Target.msPersistentStorage,
                 targets: [Target.msPersistentStorage]),
        .library(name: Target.msNetworking,
                 targets: [Target.msNetworking]),
        .library(name: Target.msCacheStorage,
                 targets: [Target.msCacheStorage]),
        .library(name: Target.msKeychainStorage,
                 targets: [Target.msKeychainStorage]),
        .library(name: Target.stateStore,
                 targets: [Target.stateStore]),
        .library(name: Target.versionManager,
                 targets: [Target.versionManager])
    ],
    dependencies: [
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        // Codes
        .target(name: Target.msImageFetcher,
                dependencies: [
                    .target(name: Target.msCacheStorage),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.msPersistentStorage,
                dependencies: [
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msConstants,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.msNetworking,
                dependencies: [
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.msCacheStorage,
                dependencies: [
                    .product(name: Dependency.msConstants,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.msKeychainStorage,
                dependencies: [
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation),
                    .product(name: Dependency.msConstants,
                             package: Dependency.msFoundation)
                ]),
        .target(name: Target.stateStore),
        .target(name: Target.versionManager,
                dependencies: [
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ]),
        
        // Tests
        .testTarget(name: Target.msPersistentStorage.testTarget,
                    dependencies: [
                        .target(name: Target.msPersistentStorage)
                    ]),
        .testTarget(name: Target.msNetworking.testTarget,
                    dependencies: [
                        .target(name: Target.msNetworking)
                    ]),
        .testTarget(name: Target.msCacheStorage.testTarget,
                    dependencies: [
                        .target(name: Target.msCacheStorage)
                    ]),
        .testTarget(name: Target.versionManager.testTarget,
                    dependencies: [
                        .target(name: Target.versionManager)
                    ])
    ],
    swiftLanguageVersions: [.v5]
)
