//
//  SpotDTO.swift
//  MSData
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct RequestableSpotDTO: Encodable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let timestamp: String
    public let photoData: Data
    
    public init(id: UUID, timestamp: String, coordinate: [Double], photoData: Data) {
        self.id = id
        self.timestamp = timestamp
        self.coordinate = coordinate
        self.photoData = photoData
    }
    
}

public struct ResponsibleSpotDTO: Identifiable {
    
    public let id: UUID
    public let coordinate: CoordinateDTO
    public let photoURL: URL
    
}

// MARK: - Decodable

extension ResponsibleSpotDTO: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "journeyId"
        case coordinate
        case photoURL = "photoUrl"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        let coordinate = try container.decode([Double].self, forKey: .coordinate)
        self.coordinate = CoordinateDTO(latitude: coordinate[0], longitude: coordinate[1])
        self.photoURL = try container.decode(URL.self, forKey: .photoURL)
    }
    
}
