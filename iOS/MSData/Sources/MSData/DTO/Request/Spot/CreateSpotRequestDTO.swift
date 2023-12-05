//
//  CreateSpotRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct CreateSpotRequestDTO {
    
    // MARK: - Properties
    
    public let journeyID: UUID
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    
    // MARK: - Initializer
    
    public init(journeyID: UUID,
                coordinate: CoordinateDTO,
                timestamp: Date) {
        self.journeyID = journeyID
        self.coordinate = coordinate
        self.timestamp = timestamp
    }
    
}

// MARK: - Encodable

extension CreateSpotRequestDTO: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinate
        case timestamp
    }
    
}
