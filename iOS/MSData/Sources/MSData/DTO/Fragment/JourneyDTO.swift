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
    public let title: String
    public let spots: [SpotDTO]
    public let coordinates: [CoordinateDTO]
    public let song: SongDTO
    
    // MARK: - Initializer
    
    public init(id: String,
                title: String,
                spots: [SpotDTO],
                coordinates: [CoordinateDTO],
                song: SongDTO) {
        self.id = id
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
        case title
        case spots
        case coordinates
        case song
    }
    
}
