//
//  SpotDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct SpotDTO {
    
    // MARK: - Properties
    
    public let journeyID: String?
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    public let photoURL: URL
    
    // MARK: - Initializer
    
    public init(journeyID: String?,
                coordinate: CoordinateDTO,
                timestamp: Date,
                photoURL: URL) {
        self.journeyID = journeyID
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURL = photoURL
    }
    
}

// MARK: - Codable

extension SpotDTO: Codable {
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinate
        case timestamp
        case photoURL = "photoUrl"
    }
    
}
