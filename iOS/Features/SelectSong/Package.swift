// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureSelectSong"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let selectSong = "SelectSong"
    
}

private enum Dependency {
    
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.selectSong,
                 targets: [Target.selectSong])
    ],
    targets: [
        .target(name:Target.selectSong)
    ]
)