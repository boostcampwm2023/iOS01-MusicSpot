//
//  Persistable.swift
//  MSData
//
//  Created by 전민건 on 2023.12.10.
//

import Foundation

import MSDomain

public protocol Persistable {
    
    func saveToLocal(value: Codable)
    func loadJourneyFromLocal() -> RecordingJourney?
    
}
