// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSFusion"

    var fromRootPath: String {
        return "../" + self
    }
}

private enum Target {
    static let msDesignSystem = "MSDesignSystem"
    static let msSwiftUI = "MSSwiftUI"
    static let msUIKit = "MSUIKit"
    static let combineCocoa = "CombineCocoa"
}

private enum Dependency {
    static let msImageFetcher = "MSImageFetcher"
    static let msCoreKit = "MSCoreKit"
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
        .library(
            name: Target.msSwiftUI,
            targets: [Target.msSwiftUI]
        ),
        .library(
            name: Target.msUIKit,
            targets: [Target.msUIKit]
        )
    ],
    dependencies: [
        .package(
            name: Dependency.msCoreKit,
            path: Dependency.msCoreKit.fromRootPath
        ),
        .package(
            name: Dependency.msFoundation,
            path: Dependency.msFoundation.fromRootPath
        ),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"
        )
    ],
    targets: [
        .target(
            name: Target.msDesignSystem,
            resources: [
                .process("../\(Target.msDesignSystem)/Resources")
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.combineCocoa,
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.msSwiftUI,
            dependencies: [
                .target(name: Target.msDesignSystem),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation
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
            name: Target.msUIKit,
            dependencies: [
                .target(name: Target.msDesignSystem),
                .target(name: Target.combineCocoa),
                .product(
                    name: Dependency.msImageFetcher,
                    package: Dependency.msCoreKit
                ),
                .product(
                    name: Dependency.msFoundation,
                    package: Dependency.msFoundation
                ),
                .product(
                    name: Dependency.msLogger,
                    package: Dependency.msFoundation
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
