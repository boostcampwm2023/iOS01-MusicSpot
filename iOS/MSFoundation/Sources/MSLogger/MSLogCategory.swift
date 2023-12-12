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
    case persistable
    case music = "MusicKit"
    
    case home
    case navigateMap
    case camera
    case spot
    case selectSong = "SelectSong"
    case saveJourney
    case journeyList
    case rewindJourney
    
}
