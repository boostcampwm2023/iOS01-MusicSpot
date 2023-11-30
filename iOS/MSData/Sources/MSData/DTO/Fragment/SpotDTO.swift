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
    
}

public struct ResponsibleSpotDTO: Decodable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let photoURLs: [String]
    
}
