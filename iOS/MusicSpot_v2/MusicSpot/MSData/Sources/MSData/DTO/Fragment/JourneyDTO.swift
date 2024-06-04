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
    public let playlist: [SongDTO]

    // MARK: - Initializer

    public init(id: String,
                metadata: JourneyMetadataDTO,
                title: String,
                spots: [SpotDTO],
                coordinates: [CoordinateDTO],
                playlist: [SongDTO]) {
        self.id = id
        self.metadata = metadata
        self.title = title
        self.spots = spots
        self.coordinates = coordinates
        self.playlist = playlist
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
        case playlist
    }
}

// MARK: - Domain Mapping

import Entity
import MSDomain

extension JourneyDTO {
    public init(_ domain: Journey) {
        self.id = domain.id
        self.metadata = JourneyMetadataDTO(startTimestamp: domain.date.start,
                                           endTimestamp: domain.date.end ?? .distantFuture)
        self.title = domain.title ?? ""
        self.spots = domain.spots.map { SpotDTO($0) }
        self.coordinates = domain.coordinates.map { CoordinateDTO($0) }
        self.playlist = domain.playlist.map { SongDTO($0) }
    }

    public func toDomain() -> Journey {
        // TODO: 바뀐 Journey 적용
        return Journey(id: self.id,
                       title: self.title,
                       date: (start: self.metadata.startTimestamp, end: self.metadata.endTimestamp),
                       coordinates: self.coordinates.map { $0.toDomain() },
                       spots: self.spots.map { $0.toDomain() },
                       playlist: [],
                       isTraveling: false)
    }
}
