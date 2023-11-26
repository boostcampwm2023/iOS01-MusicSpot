// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSUIKit"
    static let designSystem = "MSDesignSystem"
    static let components = "MSUIComponents"

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
        .library(name: .designSystem,
                 targets: [.designSystem]),
        .library(name: .components,
                 targets: [.components])
    ],
    targets: [
        // Codes
        .target(name: .designSystem),
        .target(name: .components,
                dependencies: [.target(name: .designSystem)]),
        // Tests
        .testTarget(name: .designSystem.testTarget,
                   dependencies: ["MSDesignSystem"])
    ],
    swiftLanguageVersions: [.v5]
)
