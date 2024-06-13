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
    static let dataSource = "DataSource"
    static let appRepository = "AppRepository"
    static let router = "Router"
}

private enum Dependency {
    // MSDomain
    static let entity = "Entity"
    static let msDomain = "MSDomain"
    // CoreKit
    static let msImageFetcher = "MSImageFetcher"
    static let msNetworking = "MSNetworking"
    static let msKeychainStorage = "MSKeychainStorage"
    static let msPersistentStorage = "MSPersistentStorage"
    static let msCoreKit = "MSCoreKit"
    // Foundation
    static let msExtension = "MSExtension"
    static let msLogger = "MSLogger"
    static let msUserDefaults = "MSUserDefaults"
    static let msFoundation = "MSFoundation"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: Target.dataSource,
            targets: [Target.dataSource]
        ),
        .library(
            name: Target.appRepository,
            targets: [Target.appRepository]
        )
    ],
    dependencies: [
        .package(
            name: Dependency.msDomain,
            path: Dependency.msDomain.fromRootPath
        ),
        .package(
            name: Dependency.msCoreKit,
            path: Dependency.msCoreKit.fromRootPath
        ),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"
        )
    ],
    targets: [
        .target(
            name: Target.appRepository,
            dependencies: [
                .target(name: Target.dataSource),
                .product(
                    name: Dependency.msDomain,
                    package: Dependency.msDomain
                )
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.dataSource,
            dependencies: [
                .product(
                    name: Dependency.entity,
                    package: Dependency.msDomain
                )
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        )
    ]
)
