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
	
    case recordJourney
    case rewindJourney
    case checkJourney
    case login    
    case selectSong = "SelectSong"
    case saveJourney
    case camera
    case spot
    
}
