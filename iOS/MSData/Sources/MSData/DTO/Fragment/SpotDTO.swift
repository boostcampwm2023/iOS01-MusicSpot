//
//  SpotDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct RequestableSpotDTO: Encodable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let timestamp: String
    public let photoData: Data
    
    public init(id: UUID, timestamp: String, coordinate: [Double], photoData: Data) {
        self.id = id
        self.timestamp = timestamp
        self.coordinate = coordinate
        self.photoData = photoData
    }
    
}

public struct ResponsibleSpotDTO: Decodable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let photoURLs: [String]
    public let w3w: String
    
}
