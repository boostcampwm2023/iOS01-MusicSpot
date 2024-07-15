// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "Rewind"

    var fromRootPath: String {
        "../" + self
    }
}

// MARK: - Target

private enum Target {
    static let rewind = "Rewind"
}

// MARK: - Dependency

private enum Dependency {
    enum MSDomain {
        static let package = "MSDomain"
        static let entity = "Entity"
    }

    enum MSFusion {
        static let package = "MSFusion"
        static let msSwiftUI = "MSSwiftUI"
    }
}

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(
            name: Target.rewind,
            targets: [Target.rewind]),
    ],
    dependencies: [
        .package(
            name: Dependency.MSDomain.package,
            path: Dependency.MSDomain.package.fromRootPath),
        .package(
            name: Dependency.MSFusion.package,
            path: Dependency.MSFusion.package.fromRootPath),
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"),
    ],
    targets: [
        .target(
            name: Target.rewind,
            dependencies: [
                .product(
                    name: Dependency.MSDomain.entity,
                    package: Dependency.MSDomain.package),
                .product(
                    name: Dependency.MSFusion.msSwiftUI,
                    package: Dependency.MSFusion.package),
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"),
            ]),
    ])
