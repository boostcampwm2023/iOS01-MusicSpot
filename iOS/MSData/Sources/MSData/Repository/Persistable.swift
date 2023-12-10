//
//  Persistable.swift
//  MSData
//
//  Created by 전민건 on 2023.12.10.
//

import Foundation

import MSDomain
import MSLogger
import MSPersistentStorage

public protocol Persistable {
    
    var storage: MSPersistentStorage { get }
    
    func saveToLocal(value: Codable)
    func loadJourneyFromLocal() -> RecordingJourney?
    
}

// MARK: - KeyStorage

private struct KeyStorage {
    
    static var id: String?
    static var startTimestamp: String?
    static var spots = [String]()
    static var coordinates = [String]()
    
}

// MARK: - Default Implementations

extension Persistable {
    
    @discardableResult
    public func saveToLocal(value: Codable) -> Bool {
        let key = UUID().uuidString
        self.storage.set(value: value, forKey: key)
        
        switch value {
        case is String:
            if KeyStorage.id == nil {
                KeyStorage.id = key
            } else {
                MSLogger.make(category: .persistable).debug("journey ID는 하나의 값만 저장할 수 있습니다.")
                return false
            }
        case is Date:
            if KeyStorage.startTimestamp == nil {
                KeyStorage.startTimestamp = key
            } else {
                MSLogger.make(category: .persistable).debug("start tamp는 하나의 값만 저장할 수 있습니다.")
                return false
            }
        case is SpotDTO:
            KeyStorage.spots.append(key)
        case is CoordinateDTO:
            KeyStorage.coordinates.append(key)
        default:
            MSLogger.make(category: .persistable).debug("RecordingJourney 타입의 요소들만 넣을 수 있습니다.")
            return false
        }
        return true
    }
    
    public func loadJourneyFromLocal() -> RecordingJourney? {
        guard let id = self.loadID(),
              let startTimestamp = self.loadStartTimeStamp() else {
            return nil
        }
        return RecordingJourney(id: id,
                                startTimestamp: startTimestamp,
                                spots: self.loadSpots(),
                                coordinates: self.loadCoordinates())
    }
    
    func loadStartTimeStamp() -> Date? {
        guard let startTimestampKey = KeyStorage.startTimestamp,
              let startTimestamp = self.storage.get(Date.self, forKey: startTimestampKey)
        else {
            MSLogger.make(category: .persistable).debug("id 또는 startTimestamp가 저장되지 않았습니다.")
            return nil
        }
        return startTimestamp
    }
    
    func loadID() -> String? {
        guard let idKey = KeyStorage.id,
              let id = self.storage.get(String.self, forKey: idKey) else {
            MSLogger.make(category: .persistable).debug("id 또는 startTimestamp가 저장되지 않았습니다.")
            return nil
        }
        return id
    }
    
    func loadSpots() -> [Spot] {
        return KeyStorage.spots.compactMap { spotKey in
            let spotDTO = self.storage.get(SpotDTO.self, forKey: spotKey)
            return spotDTO?.toDomain()
        }
    }
    
    func loadCoordinates() -> [Coordinate] {
        return KeyStorage.coordinates.compactMap { coordinateKey in
            let coordinateDTO = self.storage.get(CoordinateDTO.self, forKey: coordinateKey)
            return coordinateDTO?.toDomain()
        }
    }
    
}
