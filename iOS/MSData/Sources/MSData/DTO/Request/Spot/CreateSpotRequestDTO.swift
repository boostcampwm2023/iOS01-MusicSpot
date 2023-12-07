//
//  CreateSpotRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct CreateSpotRequestDTO {
    
    // MARK: - Properties
    
    public let journeyId: String
    public let coordinate: String
    public let timestamp: String
    public let photoData: Data
    
    // MARK: - Initializer
    
    public init(journeyId: String,
                coordinate: String,
                timestamp: String,
                photoData: Data) {
        self.journeyId = journeyId
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoData = photoData
    }
    
}

// MARK: - Encodable

extension CreateSpotRequestDTO: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case journeyId = "journeyId"
        case coordinate
        case timestamp
    }
    
}
