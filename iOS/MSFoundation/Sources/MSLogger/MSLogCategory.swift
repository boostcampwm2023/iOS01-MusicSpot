//
//  MSLogCategory.swift
//  MSFoundation
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public enum MSLogCategory: String {
    
    case ui = "UI"
    case network
    case imageFetcher = "ImageFetcher"
    case userDefaults
    case keychain = "Keychain"
    case fileManager = "FileManager"
    
    case home
    case navigateMap
    case camera
    case spot
    case selectSong = "SelectSong"
    case saveJourney
    case rewindJourney
    
}
