// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    
    static let package = "MSUIKit"
    
}

private enum Target {
    
    static let msDesignSystem = "MSDesignSystem"
    static let msUIKit = "MSUIKit"
    static let combineCocoa = "CombineCocoa"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.msDesignSystem,
                 targets: [Target.msDesignSystem]),
        .library(name: Target.msUIKit,
                 targets: [Target.msUIKit]),
        .library(name: Target.combineCocoa,
                 targets: [Target.combineCocoa])
    ],
    targets: [
        .target(name: Target.msDesignSystem,
                resources: [
                    .process("../\(Target.msDesignSystem)/Resources")
                ]),
        .target(name: Target.msUIKit,
                dependencies: [
                    .target(name: Target.msDesignSystem)
                ]),
        .target(name: Target.combineCocoa)
    ],
    swiftLanguageVersions: [.v5]
)
