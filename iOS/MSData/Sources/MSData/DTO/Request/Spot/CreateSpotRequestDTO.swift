//
//  CreateSpotRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct CreateSpotRequestDTO: Encodable {
    
    public let journeyID: UUID
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinate
        case timestamp
    }
    
}
