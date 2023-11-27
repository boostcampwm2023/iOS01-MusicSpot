// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSUIKit"
    static let designSystem = "MSDesignSystem"
    static let uiKit = "MSUIKit"
    
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
                 type: .static,
                 targets: [.designSystem]),
        .library(name: .uiKit,
                 targets: [.uiKit])
    ],
    targets: [
        // Codes
        .target(name: .designSystem,
                resources: [
                    .process("../\(String.designSystem)/Resources")
                ]),
        .target(name: .uiKit,
                dependencies: ["MSDesignSystem"]),
        
        // Tests
        .testTarget(name: .designSystem.testTarget,
                   dependencies: ["MSDesignSystem"])
    ],
    swiftLanguageVersions: [.v5]
)
