// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "FeatureSaveJourney"
    
    var testTarget: String {
        return self + "Tests"
    }
    
    var fromRootPath: String {
        return "../../" + self
    }
    
}

private enum Target {
    
    static let saveJourney = "SaveJourney"
    
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
<<<<<<< HEAD
        .library(name: "SaveJourney",
                 targets: ["SaveJourney"])
    ],
    dependencies: [
        .package(name: "MSUIKit",
                 path: "../../MSUIKit")
    ],
    targets: [
        .target(name: "SaveJourney",
                dependencies: ["MSUIKit"])
=======
        .library(name: Target.saveJourney,
                 targets: [Target.saveJourney])
    ],
    dependencies: [
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath)
    ],
    targets: [
        .target(name: Target.saveJourney,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit)
                ])
>>>>>>> 48567b56ec07f40e5003caf774569cbdae8f356b
    ]
)
