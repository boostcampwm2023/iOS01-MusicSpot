// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSCoreKit"
    static let persistentStorage = "MSPersistentStorage"
    static let networking = "MSNetworking"
    static let fetcher = "MSFetcher"
    static let cache = "MSCacheStorage"

    var testTarget: String {
        return self + "Tests"
    }
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: .persistentStorage,
                 targets: [.persistentStorage]),
        .library(name: .networking,
                 targets: [.networking]),
        .library(name: .fetcher,
                 targets: [.fetcher]),
        .library(name: .cache,
                 targets: [.cache])
    ],
    targets: [
        // Codes
        .target(name: .persistentStorage),
        .target(name: .networking),
        .target(name: .fetcher,
                dependencies: [
                    .target(name: .persistentStorage),
                    .target(name: .networking)
                ]),
        .target(name: .cache),

        // Tests
        .testTarget(name: .persistentStorage.testTarget,
                    dependencies: [.target(name: .persistentStorage)]),
        .testTarget(name: .networking.testTarget,
                    dependencies: [.target(name: .networking)]),
        .testTarget(name: .fetcher.testTarget,
                    dependencies: [.target(name: .fetcher)]),
        .testTarget(name: .cache.testTarget,
                    dependencies: [.target(name: .cache)])
    ],
    swiftLanguageVersions: [.v5]
)
