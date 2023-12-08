// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "MSFoundation"

    var testTarget: String {
        return self + "Tests"
    }
    
}

private enum Target {
    
    static let msConstants = "MSConstants"
    static let msExtension = "MSExtension"
    static let msLogger = "MSLogger"
    static let msUserDefaults = "MSUserDefaults"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.msConstants,
                 targets: [Target.msConstants]),
        .library(name: Target.msExtension,
                 targets: [Target.msExtension]),
        .library(name: Target.msLogger,
                 targets: [Target.msLogger]),
        .library(name: Target.msUserDefaults,
                 targets: [Target.msUserDefaults])
    ],
    targets: [
        // Codes
        .target(name: Target.msConstants),
        .target(name: Target.msExtension),
        .target(name: Target.msLogger),
        .target(name: Target.msUserDefaults),

        // Tests
        .testTarget(name: Target.msLogger.testTarget,
                    dependencies: [
                        .target(name: Target.msLogger)
                    ]),
        .testTarget(name: Target.msUserDefaults.testTarget,
                    dependencies: [
                        .target(name: Target.msUserDefaults)
                    ])
    ],
    swiftLanguageVersions: [.v5]
)
