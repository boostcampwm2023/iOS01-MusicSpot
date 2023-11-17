//
//  JourneyDTO.swift
//
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct JourneyDTO: Codable {
    
    let JourneyIdentifier: UUID
    let title: String
    let metaData: JourneyMetadataDTO
    let spots: [SpotDTO]
    let coordinates: [CoordinateDTO]
    let song: SongDTO?
    let lineColor: String
    
}
