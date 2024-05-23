//
//  JourneyRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol JourneyRepository {
    
    var isRecording: Bool { get }
    var recordingJourneyID: String? { get }
    
    func fetchJourneyList(minCoordinate: Coordinate,
                          maxCoordinate: Coordinate) async -> Result<[Journey], Error>
    func fetchRecordingJourney() -> Journey?
    mutating func startJourney(at coordinate: Coordinate, userID: UUID) async -> Result<Journey, Error>
    func recordJourney(journeyID: String, at coordinates: [Coordinate]) async -> Result<Journey, Error>
    mutating func endJourney(_ journey: Journey) async -> Result<String, Error>
    mutating func deleteJourney(_ journey: Journey, userID: UUID) async -> Result<Journey, Error>
    
}
