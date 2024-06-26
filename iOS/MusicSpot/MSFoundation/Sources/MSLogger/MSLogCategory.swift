//
//  MSLogCategory.swift
//  MSFoundation
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public enum MSLogCategory: String {
    case uiKit = "UI"
    case network
    case imageFetcher = "ImageFetcher"
    case userDefaults
    case keychain = "Keychain"
    case fileManager = "FileManager"
    case recordingJourneyStorage = "RecordingJourneyStorage"
    case music = "MusicKit"
    case version = "VersionManager"
    case locationManager

    case home
    case navigateMap
    case camera
    case spot
    case selectSong
    case saveJourney
    case journeyList
    case rewindJourney
}
