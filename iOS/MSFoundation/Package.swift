// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSFoundation"
    static let foundationExt = "FoundationExt"
    static let logger = "MSLogger"
    static let userDefaults = "MSUserDefaults"
    
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
        .library(name: .foundationExt,
                 targets: [.foundationExt]),
        .library(name: .logger,
                 targets: [.logger]),
        .library(name: .userDefaults,
                 targets: [.userDefaults])
    ],
    targets: [
        // Codes
        .target(name: .foundationExt),
        .target(name: .logger),
        .target(name: .userDefaults),
        
        // Tests
        .testTarget(name: .logger.testTarget,
                    dependencies: [.target(name: .logger)]),
        .testTarget(name: .userDefaults.testTarget,
                    dependencies: [.target(name: .userDefaults)])
    ],
    swiftLanguageVersions: [.v5]
)
