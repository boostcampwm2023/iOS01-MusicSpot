// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    static let package = "Spot"
    static let spotView = "SpotView"
    static let cameraView = "CameraView"
    static let msUIKit = "MSUIKit"
    static let msFoundation = "MSFoundation"
    static let msDesignsystem = "MSDesignSystem"
    static let msLogger = "MSLogger"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var path: String {
        return "../../" + self
    }
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: .spotView,
            targets: [.spotView]),
        .library(
            name: .cameraView,
            targets: [.cameraView])
    ],
    dependencies: [
        .package(path: .msUIKit.path),
        .package(path: .msFoundation.path)
    ],
    targets: [
        // Codes
        .target(
            name: .spotView,
            dependencies: [
                .product(name: .msUIKit, package: .msUIKit),
                .product(name: .msDesignsystem, package: .msUIKit),
                .product(name: .msLogger, package: .msFoundation)]),
        .target(
            name: .cameraView,
            dependencies: [
                .product(name: .msUIKit, package: .msUIKit),
                .product(name: .msDesignsystem, package: .msUIKit),
                .product(name: .msLogger, package: .msFoundation)])
        // Tests
    ]
)
