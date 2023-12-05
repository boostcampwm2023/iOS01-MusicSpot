//
//  CheckJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct CheckJourneyResponseDTO: Decodable {
    
    public let journeys: [JourneyDTO]
    
}
