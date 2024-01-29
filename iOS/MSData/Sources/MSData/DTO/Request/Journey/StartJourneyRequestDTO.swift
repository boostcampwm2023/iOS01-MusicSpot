//
//  StartJourneyRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct StartJourneyRequestDTO {
    
    // MARK: - Properties
    
    public let coordinate: CoordinateDTO
    public let startTimestamp: Date
    public let userID: UUID
    
    // MARK: - Initializer
    
    public init(coordinate: CoordinateDTO,
                startTimestamp: Date,
                userID: UUID) {
        self.coordinate = coordinate
        self.startTimestamp = startTimestamp
        self.userID = userID
    }
    
}

// MARK: - Encodable

extension StartJourneyRequestDTO: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case coordinate
        case startTimestamp
        case userID = "userId"
    }
    
}
