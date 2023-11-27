//
//  JourneyDTO.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct JourneyDTO: Codable, Identifiable {
    
    public let id: UUID
    let title: String
    let metaData: JourneyMetadataDTO
    let spots: [SpotDTO]
    let coordinates: [CoordinateDTO]
    let song: SongDTO
    let lineColor: String
    
}
