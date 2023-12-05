//
//  UserResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct UserResponseDTO: Encodable {
    
    public let userID: UUID
    public let journeys: [RecordJourneyRequestDTO]
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case journeys
    }
    
}
