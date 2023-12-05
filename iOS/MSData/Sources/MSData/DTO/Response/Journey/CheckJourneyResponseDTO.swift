//
//  CheckJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct CheckJourneyResponseDTO: Decodable {
    
    // MARK: - Properties
    
    public let journeys: [JourneyDTO]
    
    // MARK: - Initializer
    
    public init(journeys: [JourneyDTO]) {
        self.journeys = journeys
    }
    
}
