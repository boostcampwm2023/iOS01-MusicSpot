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
    
    static let msUIKit = "MSUIKit"
    
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
        .package(name: Dependency.msUIKit,
                 path: Dependency.msUIKit.fromRootPath)
    ],
    targets: [
        .target(name: Target.journeyList,
                dependencies: [
                    .product(name: Dependency.msUIKit,
                             package: Dependency.msUIKit)
                ])
    ]
)
