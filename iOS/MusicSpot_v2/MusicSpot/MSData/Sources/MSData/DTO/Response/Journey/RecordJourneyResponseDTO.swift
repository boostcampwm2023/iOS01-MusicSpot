//
//  RecordJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct RecordJourneyResponseDTO: Decodable {
    
    // MARK: - Properties
    
    public let coordinates: [CoordinateDTO]
    
    // MARK: - Initializer
    
    public init(coordinates: [CoordinateDTO]) {
        self.coordinates = coordinates
    }
    
}
