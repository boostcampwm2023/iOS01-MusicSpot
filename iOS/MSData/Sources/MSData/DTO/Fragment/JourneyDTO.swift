//
//  JourneyDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct JourneyDTO: Codable, Identifiable {
    
    public let id: String
    public let title: String
    public let spots: [String]
    public let coordinates: [CoordinateDTO]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case spots
        case coordinates
    }
    
}
