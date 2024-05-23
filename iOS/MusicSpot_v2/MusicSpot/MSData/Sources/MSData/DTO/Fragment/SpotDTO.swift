//
//  SpotDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct SpotDTO {
    
    // MARK: - Properties
    
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    public let photoURLs: [URL]
    
    // MARK: - Initializer
    
    public init(coordinate: CoordinateDTO,
                timestamp: Date,
                photoURLs: [URL]) {
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURLs = photoURLs
    }
    
}

// MARK: - Codable

extension SpotDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case coordinate
        case timestamp
        case photoURLs = "photoUrls"
    }
    
}

// MARK: - Domain Mapping

import Entity
import MSDomain

extension SpotDTO {
    
    public init(_ domain: Spot) {
        self.coordinate = CoordinateDTO(domain.coordinate)
        self.timestamp = domain.timestamp
        self.photoURLs = domain.photoURLs
    }
    
    public func toDomain() -> Spot {
        return Spot(coordinate: self.coordinate.toDomain(),
                    timestamp: self.timestamp,
                    photoURLs: self.photoURLs)
    }
    
}
