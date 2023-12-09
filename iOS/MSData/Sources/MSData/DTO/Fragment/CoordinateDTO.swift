//
//  CoordinateDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

// Incoming Data:
// [37.555946, 126.972384],
// [37.555946, 126.972384]

public struct CoordinateDTO {
    
    // MARK: - Properties
    
    public let latitude: Double
    public let longitude: Double
    
    // MARK: - Initializer
    
    public init(latitude: Double,
                longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

// MARK: - Codable

extension CoordinateDTO: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([self.latitude, self.longitude])
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let coordinates = try container.decode([Double].self)
        
        guard coordinates.count == 2 else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Coordinate 값은 2개 값으로 이루어진 배열이어야 합니다.")
        }
        self.latitude = coordinates[0]
        self.longitude = coordinates[1]
    }
    
}

// MARK: - Domain Mapping

import MSDomain

extension CoordinateDTO {
    
    public init(_ domain: Coordinate) {
        self.latitude = domain.latitude
        self.longitude = domain.longitude
    }
    
    public func toDomain() -> Coordinate {
        return Coordinate(latitude: self.latitude,
                          longitude: self.longitude)
    }
    
}
