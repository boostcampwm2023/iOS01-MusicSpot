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
    public let timestamp: String
    public let photoURL: URL
    
    // MARK: - Initializer
    
    public init(journeyID: String?,
                coordinate: CoordinateDTO,
                timestamp: String,
                photoURL: URL) {
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURL = photoURL
    }
    
}

// MARK: - Codable

extension SpotDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case coordinate
        case timestamp
        case photoURL = "photoUrl"
    }
    
}

// MARK: - Domain Mapping

import MSDomain

extension SpotDTO {
    
    public init(_ domain: Spot) {
        self.coordinate = CoordinateDTO(domain.coordinate)
        self.timestamp = domain.timestamp
        self.photoURL = domain.photoURL
    }
    
    public func toDomain() -> Spot {
        return Spot(coordinate: self.coordinate.toDomain(),
                    timestamp: self.timestamp,
                    photoURL: self.photoURL)
    }
    
}
