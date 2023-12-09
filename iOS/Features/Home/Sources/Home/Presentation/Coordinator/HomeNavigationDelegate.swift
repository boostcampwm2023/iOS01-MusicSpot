//
//  HomeNavigationDelegate.swift
//  Home
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSDomain

public protocol HomeNavigationDelegate: AnyObject {
    
    func navigateToSpot(recordingJourney: RecordingJourney, coordinate: Coordinate)
    func navigateToSelectSong(recordingJourney: RecordingJourney, lastCoordinate: Coordinate)
    
}
