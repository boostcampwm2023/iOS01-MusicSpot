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
    static let usecase = "UseCase"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: Target.msDomain,
            targets: [
                Target.entity,
                Target.msDomain,
                Target.usecase
            ]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/realm/SwiftLint.git",
            from: "0.55.1"
        )
    ],
    targets: [
        .target(name: Target.entity),
        .target(
            name: Target.msDomain,
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
                .target(name: Target.entity)
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
