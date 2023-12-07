//
//  SelectSongNavigationDelegate.swift
//  SelectSong
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation
import MusicKit

import MSDomain

public protocol SelectSongNavigationDelegate: AnyObject {
    
    func navigateToSaveJourney(recordingJourney: RecordingJourney,
                               lastCoordinate: Coordinate,
                               selectedSong: Song,
                               selectedIndex: IndexPath)
    
}
