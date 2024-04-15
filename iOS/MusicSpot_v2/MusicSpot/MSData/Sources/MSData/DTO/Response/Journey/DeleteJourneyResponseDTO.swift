//
//  DeleteJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

public struct DeleteJourneyResponseDTO: Identifiable {
    
    // MARK: - Properties
    
    public let id: String
    public let metadata: JourneyMetadataDTO
    public let spots: [SpotDTO]
    public let coordinates: [CoordinateDTO]
    
    // MARK: - Initializer
    
    public init(id: String,
                metadata: JourneyMetadataDTO,
                spots: [SpotDTO],
                coordinates: [CoordinateDTO]) {
        self.id = id
        self.metadata = metadata
        self.spots = spots
        self.coordinates = coordinates
    }
    
}

// MARK: - Decodable

extension DeleteJourneyResponseDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata = "journeyMetadata"
        case spots
        case coordinates
    }
    
}

// MARK: - Domain Mapping

import MSDomain

extension DeleteJourneyResponseDTO {
    
    public func toDomain() -> RecordingJourney {
        return RecordingJourney(id: self.id,
                                startTimestamp: self.metadata.startTimestamp,
                                spots: self.spots.map { $0.toDomain() },
                                coordinates: self.coordinates.map { $0.toDomain() })
    }
    
}
