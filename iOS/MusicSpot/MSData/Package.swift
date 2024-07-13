// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSData"

    var testTarget: String {
        self + "Tests"
    }

    var fromRootPath: String {
        "../" + self
    }
}

// MARK: - Target

private enum Target {
    static let msData = "MSData"
    static let dataSource = "DataSource"
    static let appRepository = "AppRepository"
    static let remoteRepository = "RemoteRepository"
    static let repository = "Repository"
    static let router = "Router"
}

// MARK: - Dependency

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
    static let msLogger = "MSLogger"
    static let msUserDefaults = "MSUserDefaults"
    static let msFoundation = "MSFoundation"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.dataSource,
            targets: [Target.dataSource]),
        .library(
            name: Target.repository,
            targets: [
                Target.appRepository,
                Target.remoteRepository,
            ]),
    ],
    dependencies: [
        .package(
            name: Dependency.msDomain,
            path: Dependency.msDomain.fromRootPath),
        .package(
            name: Dependency.msCoreKit,
            path: Dependency.msCoreKit.fromRootPath),
        .package(
            name: Dependency.msFoundation,
            path: Dependency.msFoundation.fromRootPath),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"),
    ],
    targets: [
        .target(
            name: Target.appRepository,
            dependencies: [
                .target(name: Target.dataSource),
                .product(
                    name: Dependency.msDomain,
                    package: Dependency.msDomain),
                .product(
                    name: Dependency.msImageFetcher,
                    package: Dependency.msCoreKit),
                .product(
                    name: Dependency.msUserDefaults,
                    package: Dependency.msFoundation),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .target(
            name: Target.remoteRepository,
            dependencies: [
                .product(
                    name: Dependency.msDomain,
                    package: Dependency.msDomain),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .target(
            name: Target.dataSource,
            dependencies: [
                .product(
                    name: Dependency.entity,
                    package: Dependency.msDomain),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
        .testTarget(
            name: Target.appRepository.testTarget,
            dependencies: [
                .target(name: Target.appRepository),
            ]),
    ])
