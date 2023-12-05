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
    
    public let latitude: Double
    public let longitude: Double
    
}

// MARK: - Codable

extension CoordinateDTO: Codable {
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode([self.latitude, self.longitude])
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let coordinates = try container.decode([Double].self)
        
        guard coordinates.count == 2 else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Coordinate 값은 2개 값으로 이루어진 배열이어야 합니다.")
        }
        
        self.latitude = coordinates[0]
        self.longitude = coordinates[1]
    }
    
}
