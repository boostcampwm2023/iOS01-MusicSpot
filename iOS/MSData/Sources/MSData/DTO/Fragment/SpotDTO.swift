//
//  SpotDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct SpotDTO: Codable, Identifiable {
    
    public let id: UUID
    public let coordinate: [Double]
    public let photoURLs: [String]
    
}
