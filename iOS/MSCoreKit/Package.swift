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
    static let msFetcher = "MSFetcher"
    static let msCacheStorage = "MSCacheStorage"
    
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
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.msImageFetcher,
                 targets: [Target.msImageFetcher]),
        .library(name: Target.msPersistentStorage,
                 targets: [Target.msPersistentStorage]),
        .library(name: Target.msNetworking,
                 targets: [Target.msNetworking]),
        .library(name: Target.msFetcher,
                 targets: [Target.msFetcher]),
        .library(name: Target.msCacheStorage,
                 targets: [Target.msCacheStorage])
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
        .target(name: Target.msPersistentStorage),
        .target(name: Target.msNetworking),
        .target(name: Target.msFetcher,
                dependencies: [
                    .target(name: Target.msPersistentStorage),
                    .target(name: Target.msNetworking)
                ]),
        .target(name: Target.msCacheStorage,
                dependencies: [
                    .product(name: Dependency.msConstants,
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
        .testTarget(name: Target.msFetcher.testTarget,
                    dependencies: [
                        .target(name: Target.msFetcher)
                    ]),
        .testTarget(name: Target.msCacheStorage.testTarget,
                    dependencies: [
                        .target(name: Target.msCacheStorage)
                    ])
    ],
    swiftLanguageVersions: [.v5]
)
