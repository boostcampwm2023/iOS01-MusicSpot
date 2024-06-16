// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "MSDomain"

    var fromRootPath: String {
        return "../" + self
    }
}

private enum Target {
    static let msDomain = "MSDomain"
    static let entity = "Entity"
    static let repository = "Repository"
    static let usecase = "UseCase"
}

private enum Dependency {
    static let msData = "MSData"
    static let repository = "Repository"
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
            name: Target.entity,
            targets: [Target.entity]
        ),
        .library(
            name: Target.msDomain,
            targets: [
                Target.repository,
                Target.usecase
            ]
        )
    ],
    dependencies: [
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
        .target(name: Target.entity),
        .target(
            name: Target.repository,
            dependencies: [
                .target(name: Target.entity)
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLint"
                )
            ]
        ),
        .target(
            name: Target.usecase,
            dependencies: [
                .target(name: Target.entity),
                .target(name: Target.repository)
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
        )
    ]
)
