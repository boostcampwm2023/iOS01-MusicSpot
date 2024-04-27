// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

extension String {
    
    static let package = "Journey"
    
    var fromRootPath: String {
        return "../" + self
    }
    
}

private enum Target {
    
    static let journey = "Journey"
    
}

private enum Dependency {
    
    enum MSFusion {
        static let package = "MSFusion"
        static let msSwiftUI = "MSSwiftUI"
    }
    
    enum MSCoreKit {
        static let package = "MSCoreKit"
        static let msLocationManager = "MSLocationManager"
    }
    
}

// MARK: - Package

let package = Package(
    name: .package,
    products: [
        .library(
            name: Target.journey,
            targets: [Target.journey]),
    ],
    targets: [
        .target(
            name: Target.journey)
    ]
)
