//
//  JourneyDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct JourneyDTO: Codable, Identifiable {
    
    public let id: UUID
    public let location: String
    public let metaData: JourneyMetadataDTO
    public let spots: [SpotDTO]
    public let coordinates: [CoordinateDTO]
    public let song: SongDTO
    public let lineColor: String
    
}
