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
    public let photoData: Data
    
    public init(id: UUID, coordinate: [Double], photoData: Data) {
        self.id = id
        self.coordinate = coordinate
        self.photoData = photoData
    }
    
}

public struct ResponsibleSpotDTO: Decodable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let photoURLs: [String]
    
    public init(id: UUID, coordinate: [Double], photoURLs: [String]) {
        self.id = id
        self.coordinate = coordinate
        self.photoURLs = photoURLs
    }
    
}
