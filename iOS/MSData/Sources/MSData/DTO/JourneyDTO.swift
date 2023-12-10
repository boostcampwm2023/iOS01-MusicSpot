//
//  JourneyDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct JourneyDTO: Decodable, Identifiable {
    
    public let id: UUID
    public let location: String
    public let metaData: JourneyMetadataDTO
    public let spots: [ResponsibleSpotDTO]
    public let coordinates: [CoordinateDTO]
    public let song: SongDTO
    public let lineColor: String
    
}

