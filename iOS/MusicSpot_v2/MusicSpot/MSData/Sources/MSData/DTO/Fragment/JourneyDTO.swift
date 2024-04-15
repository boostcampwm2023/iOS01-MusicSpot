//
//  JourneyDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct JourneyDTO: Identifiable {
    
    // MARK: - Properties
    
    public let id: String
    public let metadata: JourneyMetadataDTO
    public let title: String
    public let spots: [SpotDTO]
    public let coordinates: [CoordinateDTO]
    public let song: SongDTO
    
    // MARK: - Initializer
    
    public init(id: String,
                metadata: JourneyMetadataDTO,
                title: String,
                spots: [SpotDTO],
                coordinates: [CoordinateDTO],
                song: SongDTO) {
        self.id = id
        self.metadata = metadata
        self.title = title
        self.spots = spots
        self.coordinates = coordinates
        self.song = song
    }
    
}

// MARK: - Codable

extension JourneyDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case metadata = "journeyMetadata"
        case title
        case spots
        case coordinates
        case song
    }
    
}

// MARK: - Domain Mapping

import MSDomain

extension JourneyDTO {
    
    public init(_ domain: Journey) {
        self.id = domain.id
        self.metadata = JourneyMetadataDTO(startTimestamp: domain.date.start,
                                           endTimestamp: domain.date.end)
        self.title = domain.title
        self.spots = domain.spots.map { SpotDTO($0) }
        self.coordinates = domain.coordinates.map { CoordinateDTO($0) }
        self.song = SongDTO(domain.music)
    }
    
    public func toDomain() -> Journey {
        return Journey(id: self.id,
                       title: self.title,
                       date: (start: self.metadata.startTimestamp, end: self.metadata.endTimestamp),
                       spots: self.spots.map { $0.toDomain() },
                       coordinates: self.coordinates.map { $0.toDomain() },
                       music: self.song.toDomain())
    }
    
}
