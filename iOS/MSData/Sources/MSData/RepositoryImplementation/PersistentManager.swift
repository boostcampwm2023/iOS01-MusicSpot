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

// MARK: - KeyStorage

private struct KeyStorage {
    
    static var id: String?
    static var startTimestamp: String?
    static var spots = [String]()
    static var coordinates = [String]()
    
}

// MARK: - Default Implementations

 public struct PersistentManager {
     
    static let shared = PersistentManager()
    
    @discardableResult
    public func saveToLocal(_ value: Codable, at storage: MSPersistentStorage) -> Bool {
        let key = UUID().uuidString
        storage.set(value: value, forKey: key)
        
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
                MSLogger.make(category: .persistable).debug("start timestamp는 하나의 값만 저장할 수 있습니다.")
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
    
    public func loadJourney(from storage: MSPersistentStorage) -> RecordingJourney? {
        guard let id = self.loadID(from: storage),
              let startTimestamp = self.loadStartTimeStamp(from: storage) else {
            return nil
        }
        return RecordingJourney(id: id,
                                startTimestamp: startTimestamp,
                                spots: self.loadSpots(from: storage),
                                coordinates: self.loadCoordinates(from: storage))
    }
    
    func loadStartTimeStamp(from storage: MSPersistentStorage) -> Date? {
        guard let startTimestampKey = KeyStorage.startTimestamp,
              let startTimestamp = storage.get(Date.self, forKey: startTimestampKey)
        else {
            MSLogger.make(category: .persistable).debug("id 또는 startTimestamp가 저장되지 않았습니다.")
            return nil
        }
        return startTimestamp
    }
    
    func loadID(from storage: MSPersistentStorage) -> String? {
        guard let idKey = KeyStorage.id,
              let id = storage.get(String.self, forKey: idKey) else {
            MSLogger.make(category: .persistable).debug("id 또는 startTimestamp가 저장되지 않았습니다.")
            return nil
        }
        return id
    }
    
    func loadSpots(from storage: MSPersistentStorage) -> [Spot] {
        return KeyStorage.spots.compactMap { spotKey in
            let spotDTO = storage.get(SpotDTO.self, forKey: spotKey)
            return spotDTO?.toDomain()
        }
    }
    
    func loadCoordinates(from storage: MSPersistentStorage) -> [Coordinate] {
        return KeyStorage.coordinates.compactMap { coordinateKey in
            let coordinateDTO = storage.get(CoordinateDTO.self, forKey: coordinateKey)
            return coordinateDTO?.toDomain()
        }
    }
    
}
