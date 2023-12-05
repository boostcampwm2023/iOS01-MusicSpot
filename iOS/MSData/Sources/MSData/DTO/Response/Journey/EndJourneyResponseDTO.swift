//
//  EndJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct EndJourneyResponseDTO: Decodable {
    
    public let journeyID: UUID
    public let coordinate: CoordinateDTO
    public let numberOfCoordinates: Int
    public let endTimestamp: Date
    
}
