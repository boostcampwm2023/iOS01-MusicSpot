//
//  RecordingJourneyStorage.swift
//  MSData
//
//  Created by 전민건 on 2023.12.10.
//

import Foundation

import MSConstants
import MSDomain
import MSLogger
import MSPersistentStorage
import MSUserDefaults

// MARK: - Default Implementations

public struct RecordingJourneyStorage {
    
    // MARK: - Properties
    
    private let storage: MSPersistentStorage
    
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    private(set) var isRecording: Bool
    
    @UserDefaultsWrapped(UserDefaultsKey.recordingJourneyID, defaultValue: nil)
    private(set) var recordingJourneyID: String?
    
    /// 기록중인 여정의 ID
    public var id: String? {
        return self.recordingJourneyID
    }
    
    /// 기록중인 여정 정보
    public var currentState: RecordingJourney? {
        return self.fetchRecordingJourney()
    }
    
    // MARK: - Initializer
    
    public init(storage: MSPersistentStorage = FileManagerStorage()) {
        self.storage = storage
    }
    
    // MARK: - Shared
    
    public static let shared = RecordingJourneyStorage()
    
    // MARK: - Functions
    
    public mutating func start(initialData recordingJourney: RecordingJourney) {
        defer { self.isRecording = true }
        
        // 삭제되지 않은 이전 여정 기록이 남아있다면 삭제
        if self.recordingJourneyID != nil {
            do {
                try self.finish()
            } catch {
                MSLogger.make(category: .recordingJourneyStorage)
                    .warning("삭제되지 않은 이전 여정 기록 초기화에 실패했습니다.")
            }
        }
        
        self.recordingJourneyID = recordingJourney.id
        
        if let startTimestampKey = self.key(recordingJourney.id,
                                            forProperty: \.startTimestamp) {
            do {
                try self.storage.set(value: recordingJourney.startTimestamp,
                                     forKey: startTimestampKey,
                                     subpath: recordingJourney.id)
            } catch {
                MSLogger.make(category: .recordingJourneyStorage)
                    .error("여정 기록 시작 Timestamp를 기록할 수 없습니다: \(recordingJourney.startTimestamp)")
            }
        } else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("Start Timestamp에 대한 기록이 실패했습니다.")
        }
    }
    
    @discardableResult
    public func record<T: Codable>(_ values: [T], keyPath: KeyPath<RecordingJourneyDTO, [T]>) -> Bool {
        guard let recordingJourneyID = self.recordingJourneyID else {
            MSLogger.make(category: .recordingJourneyStorage)
                .error("recordingJourneyID를 조회할 수 없습니다. 여정이 기록 중인지 확인해주세요.")
            return false
        }
        
        if let key = self.key(recordingJourneyID, forProperty: keyPath) {
            let recordingValues = self.makeRecordingValue(appendingValues: values,
                                                          forKey: key,
                                                          subpath: recordingJourneyID)
            do {
                try self.storage.set(value: recordingValues,
                                     forKey: key,
                                     subpath: recordingJourneyID)
            } catch {
                MSLogger.make(category: .recordingJourneyStorage)
                    .error("여정 좌표를 기록할 수 없습니다: \(recordingValues)")
            }
            return true
        } else {
            return false
        }
    }
    
    public mutating func finish() throws {
        guard let recordingJourneyID = self.recordingJourneyID else { return }
        try self.storage.deleteAll(subpath: recordingJourneyID)
        
        self.isRecording = false
        self.recordingJourneyID = nil
        
#if DEBUG
        MSLogger.make(category: .recordingJourneyStorage).debug("여정 기록을 종료합니다: \(recordingJourneyID)")
#endif
    }
    
}

// MARK: - Private Functions

private extension RecordingJourneyStorage {
    
    private enum Prefix {
        static let idKey = "id"
        static let startTimestampKey = "ts"
        static let spotsKey = "sp"
        static let coordinatesKey = "co"
    }
    
    func key<T>(_ key: String, forProperty keyPath: KeyPath<RecordingJourneyDTO, T>) -> String? {
        switch keyPath {
        case \.id: return Prefix.idKey + key
        case \.startTimestamp: return Prefix.startTimestampKey + key
        case \.spots: return Prefix.spotsKey + key
        case \.coordinates: return Prefix.coordinatesKey + key
        default: return nil
        }
    }
    
    func fetchRecordingJourney() -> RecordingJourney? {
        guard let id = self.id,
              let startTimestamp = self.fetchStartTimeStamp() else {
            return nil
        }
        return RecordingJourney(id: id,
                                startTimestamp: startTimestamp,
                                spots: self.fetchSpots(),
                                coordinates: self.fetchCoordinates())
    }
    
    func fetchStartTimeStamp() -> Date? {
        guard let recordingJourneyID = self.recordingJourneyID,
              let startTimestampKey = self.key(recordingJourneyID, forProperty: \.startTimestamp),
              let startTimestamp = try? self.storage.get(Date.self,
                                                         forKey: startTimestampKey,
                                                         subpath: recordingJourneyID) else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("기록중인 여정에서 StartTimestamp를 불러오지 못했습니다.")
            return nil
        }
        return startTimestamp
    }
    
    func fetchSpots() -> [Spot] {
        guard let recordingJourneyID = self.recordingJourneyID,
              let spotKey = self.key(recordingJourneyID, forProperty: \.spots),
              let spots = try? self.storage.get([SpotDTO].self,
                                                forKey: spotKey,
                                                subpath: recordingJourneyID) else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("기록중인 여정에서 Spot 목록을 불러오지 못했습니다.")
            return []
        }
        
        return spots.map { $0.toDomain() }
    }
    
    func fetchCoordinates() -> [Coordinate] {
        guard let recordingJourneyID = self.recordingJourneyID,
              let coordinateKey = self.key(recordingJourneyID, forProperty: \.coordinates),
              let coordinates = try? self.storage.get([CoordinateDTO].self,
                                                      forKey: coordinateKey,
                                                      subpath: recordingJourneyID) else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("기록중인 여정에서 Coordinate 목록을 불러오지 못했습니다.")
            return []
        }
        
        return coordinates.map { $0.toDomain() }
    }
    
    /// 기록 중인 이전 데이터가 남아있다면 새로운 데이터를 이전 데이터에 합칩니다.
    /// 이전에 기록한 데이터가 없는 새로운 데이터라면 주어진 데이터를 그대로 반환합니다.
    func makeRecordingValue<T: Codable>(appendingValues values: [T],
                                        forKey key: String,
                                        subpath: String? = nil) -> [T] {
        guard let recordedData = try? self.storage.get([T].self, forKey: key, subpath: subpath) else {
            return values
        }
        
        return recordedData + values
    }
    
}
