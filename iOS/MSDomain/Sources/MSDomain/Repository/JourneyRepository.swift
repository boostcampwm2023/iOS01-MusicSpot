//
//  JourneyRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

public protocol JourneyRepository {
    
    func fetchIsRecording() -> Bool
    mutating func updateIsRecording(_ isRecording: Bool) -> Bool
    func fetchRecordingJourneyID() -> String?
    func fetchRecordingJourney(forID id: String) -> RecordingJourney?
    func fetchJourneyList(userID: UUID,
                          minCoordinate: Coordinate,
                          maxCoordinate: Coordinate) async -> Result<[Journey], Error>
    mutating func startJourney(at coordinate: Coordinate, userID: UUID) async -> Result<RecordingJourney, Error>
    mutating func endJourney(_ journey: Journey) async -> Result<String, Error>
    func recordJourney(journeyID: String, at coordinates: [Coordinate]) async -> Result<RecordingJourney, Error>
    mutating func deleteJourney(_ journey: RecordingJourney, userID: UUID) async -> Result<String, Error>
    
}
