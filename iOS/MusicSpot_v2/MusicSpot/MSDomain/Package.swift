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
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: Target.msDomain,
                 targets: [Target.msDomain])
    ],
    targets: [
        .target(name: Target.msDomain)
    ],
    swiftLanguageVersions: [.v5]
)
