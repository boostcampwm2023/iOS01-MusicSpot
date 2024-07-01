// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    static let package = "FeatureJourneyList"

    var fromRootPath: String {
        return "../../" + self
    }
}

private enum Target {
    static let journeyList = "JourneyList"
}

private enum Dependency {
    static let msData = "MSData"
    
    static let msUIKit = "MSUIKit"
    static let msFusion = "MSFusion"
    
    static let msLogger = "MSLogger"
    static let msFoundation = "MSFoundation"
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.journeyList,
                 targets: [Target.journeyList])
    ],
    dependencies: [
        .package(name: Dependency.msData,
                 path: Dependency.msData.fromRootPath),
        .package(name: Dependency.msFusion,
                 path: Dependency.msFusion.fromRootPath),
        .package(name: Dependency.msFoundation,
                 path: Dependency.msFoundation.fromRootPath)
    ],
    targets: [
        .target(name: Target.journeyList,
                dependencies: [
                    .product(name: Dependency.msData,
                             package: Dependency.msData),
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msFusion),
                    .product(name: Dependency.msLogger,
                             package: Dependency.msFoundation)
                ])
    ]
)