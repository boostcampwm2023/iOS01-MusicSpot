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
        // 삭제되지 않은 이전 여정 기록이 남아있다면 삭제
        if let previousRecordingJourneyID = self.recordingJourneyID {
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
            self.storage.set(value: recordingJourney.startTimestamp,
                             forKey: startTimestampKey,
                             subpath: recordingJourney.id)
        } else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("Start Timestamp에 대한 기록이 실패했습니다.")
        }
    }
    
    @discardableResult
    public func record<T: Codable>(_ value: T, keyPath: KeyPath<RecordingJourneyDTO, T>) -> Bool {
        guard let recordingJourneyID = self.recordingJourneyID else {
            MSLogger.make(category: .recordingJourneyStorage)
                .error("recordingJourneyID를 조회할 수 없습니다. 여정이 기록 중인지 확인해주세요.")
            return false
        }
        
        if let key = self.key(recordingJourneyID, forProperty: keyPath) {
            // TODO: 기록중이던 Spot이나 Coordinate가 있을 경우, 이전 기록에 합쳐 저장
            self.storage.set(value: value, forKey: key, subpath: recordingJourneyID)
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
    }
    
}

// MARK: - Private Functions

private extension RecordingJourneyStorage {
    
    func key<T>(_ key: String, forProperty keyPath: KeyPath<RecordingJourneyDTO, T>) -> String? {
        switch keyPath {
        case \.id: return "id" + key
        case \.startTimestamp: return "ts" + key
        case \.spots: return "sp" + key
        case \.coordinates: return "co" + key
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
              let startTimestamp = self.storage.get(Date.self,
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
              let spots = self.storage.get([SpotDTO].self,
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
              let coordinates = self.storage.get([CoordinateDTO].self,
                                                 forKey: coordinateKey,
                                                 subpath: recordingJourneyID) else {
            MSLogger.make(category: .recordingJourneyStorage)
                .warning("기록중인 여정에서 Coordinate 목록을 불러오지 못했습니다.")
            return []
        }
        
        return coordinates.map { $0.toDomain() }
    }
    
}
