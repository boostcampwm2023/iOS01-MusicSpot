// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
<<<<<<< HEAD

=======
>>>>>>> 48567b56ec07f40e5003caf774569cbdae8f356b
import PackageDescription

let package = Package(
    name: "MSData",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "MSData",
                 targets: ["MSData"])
    ],
    dependencies: [
        .package(name: "MSNetworking",
                 path: "../MSCoreKit")
    ],
    targets: [
        .target(name: "MSData",
                dependencies: ["MSNetworking"],
                resources: [.process("Resources")]),
        .testTarget(name: "MSDataTests",
                    dependencies: ["MSData"])
    ]
)
