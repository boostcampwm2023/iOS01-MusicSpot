// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    
    static let package = "FeatureHome"
    
    var fromRootPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let home = "Home"
    
}

private enum Dependency {
    
    static let msSwiftUI = "MSSwiftUI"
    static let msFusion = "MSFusion"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: Target.home,
            targets: [Target.home]
        ),
    ],
    dependencies: [
        .package(
            name: Dependency.msFusion,
            path: Dependency.msFusion.fromRootPath
        )
    ],
    targets: [
        .target(
            name: Target.home,
            dependencies: [
                .product(
                    name: Dependency.msSwiftUI,
                    package: Dependency.msFusion
                )
            ]
        )
    ]
)
