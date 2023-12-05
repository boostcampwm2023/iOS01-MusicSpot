//
//  StartJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct StartJourneyResponseDTO: Decodable {
    
    public let coordinate: CoordinateDTO
    public let startTimestamp: Date
    public let userID: UUID
    
    enum CodingKeys: String, CodingKey {
        case coordinate
        case startTimestamp
        case userID = "userId"
    }
    
}
