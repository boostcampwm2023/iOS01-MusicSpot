//
//  Persistable.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.26.
//

import Foundation

public protocol Persistable {
    
    @discardableResult
    func saveToLocal(_ value: Codable, at storage: MSPersistentStorage) -> Bool
    func loadJourney() -> RecordingJourney?
    
}
