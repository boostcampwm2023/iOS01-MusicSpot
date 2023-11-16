//
//  JournalDTO.swift
//  
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct JournalDTO {
    let journalIdentifier: UUID
    let title: String
    let metaData: JournalMetadataDTO
    let spots: [SpotDTO]
    let coordinates: [CoordinateDTO]
    let song: SongDTO?
    let lineColor: String
}
