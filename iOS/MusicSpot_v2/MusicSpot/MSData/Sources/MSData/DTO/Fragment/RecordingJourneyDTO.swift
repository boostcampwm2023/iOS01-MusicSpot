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

import Entity
import MSDomain

extension RecordingJourneyDTO {
    
    public init(_ domain: Journey) {
        self.id = domain.id
        self.startTimestamp = domain.date.start
        self.spots = domain.spots.map { SpotDTO($0) }
        self.coordinates = domain.coordinates.map { CoordinateDTO($0) }
    }
    
    public func toDomain() -> Journey {
        // TODO: 바뀐 Journey 적용
        return Journey(id: self.id,
                       title: "",
                       date: (start: self.startTimestamp, end: nil),
                       coordinates: self.coordinates.map { $0.toDomain() },
                       spots: self.spots.map { $0.toDomain() },
                       playlist: [])
    }
    
}
