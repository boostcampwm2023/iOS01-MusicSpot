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

import Entity
import MSDomain

extension DeleteJourneyResponseDTO {
    public func toDomain() -> Journey {
        // TODO: 바뀐 Journey 적용
        return Journey(id: self.id,
                       title: "",
                       date: (start: self.metadata.startTimestamp, end: nil),
                       coordinates: self.coordinates.map { $0.toDomain() },
                       spots: self.spots.map { $0.toDomain() },
                       playlist: [],
                       isTraveling: false)
    }
}
