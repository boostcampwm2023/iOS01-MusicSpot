// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Constants

private extension String {
    
    static let package = "Feature"
    
    var fromPackagesPath: String {
        return "Packages/" + self
    }
    
}

private enum Target {
    
    static let feature = "Feature"
    
}

private enum Dependency {
    
    static let featureHome = "FeatureHome"
    static let home = "Home"
    static let navigateMap = "NavigateMap"
    
    static let featureJourneyList = "FeatureJourneyList"
    static let journeyList = "JourneyList"
    
    static let featureRewindJourney = "FeatureRewindJourney"
    static let rewindJourney = "RewindJourney"
    
    static let featureSaveJourney = "FeatureSaveJourney"
    static let saveJourney = "SaveJourney"
    
    static let featureSelectSong = "FeatureSelectSong"
    static let selectSong = "SelectSong"
    
    static let featureSpot = "FeatureSpot"
    static let spot = "Spot"
    
}

// MARK: - Package

let package = Package(
    name: .package,
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: Target.feature,
                 targets: [Target.feature]),
    ],
    dependencies: [
        .package(name: Dependency.featureHome,
                 path: Dependency.home.fromPackagesPath),
        .package(name: Dependency.featureJourneyList,
                 path: Dependency.journeyList.fromPackagesPath),
        .package(name: Dependency.featureRewindJourney,
                 path: Dependency.rewindJourney.fromPackagesPath),
        .package(name: Dependency.featureSaveJourney,
                 path: Dependency.saveJourney.fromPackagesPath),
        .package(name: Dependency.featureSelectSong,
                 path: Dependency.selectSong.fromPackagesPath),
        .package(name: Dependency.featureSpot,
                 path: Dependency.spot.fromPackagesPath)
    ],
    targets: [
        .target(name: Target.feature,
                dependencies: [
                    .product(name: Dependency.home,
                             package: Dependency.featureHome),
                    .product(name: Dependency.navigateMap,
                             package: Dependency.featureHome),
                    .product(name: Dependency.journeyList,
                             package: Dependency.featureJourneyList),
                    .product(name: Dependency.rewindJourney,
                             package: Dependency.featureRewindJourney),
                    .product(name: Dependency.saveJourney,
                             package: Dependency.featureSaveJourney),
                    .product(name: Dependency.selectSong,
                             package: Dependency.featureSelectSong),
                    .product(name: Dependency.spot,
                             package: Dependency.featureSpot)
                ])
    ],
    swiftLanguageVersions: [.v5]
)
