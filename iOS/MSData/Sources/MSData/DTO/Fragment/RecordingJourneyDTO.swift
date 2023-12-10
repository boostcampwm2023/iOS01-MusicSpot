//
//  RecordingJourneyDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

public struct RecordingJourneyDTO: Codable {
    
    public let id: String
    public let startTimestamp: Date
    public let spots: [SpotDTO]
    public let coordinates: [CoordinateDTO]
    
}

// MARK: - Domain Mapping

import MSDomain

extension RecordingJourneyDTO {
    
    public init(_ domain: RecordingJourney) {
        self.id = domain.id
        self.startTimestamp = domain.startTimestamp
        self.spots = domain.spots.map { SpotDTO($0) }
        self.coordinates = domain.coordinates.map { CoordinateDTO($0) }
    }
    
    public func toDomain() -> RecordingJourney {
        return RecordingJourney(id: self.id,
                                startTimestamp: self.startTimestamp,
                                spots: self.spots.map { $0.toDomain() },
                                coordinates: self.coordinates.map { $0.toDomain() })
    }
    
}
