//
//  DTO+Mapping.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation
import CoreLocation

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.title = dto.title
        self.spots = dto.spots.map { Spot(dto: $0) }
        // TODO: API 변경 후 적용
        self.date = .now
        self.song = Song(dto: dto.song)
    }
    
}

extension Spot {
    
    init(dto: SpotDTO) {
        self.location = Coordinate(dto: dto.coordinate)
        self.date = .now
        self.photoURL = dto.photoURL
    }
    
}

extension Coordinate {
    
    init(dto: CoordinateDTO) {
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
    
}

extension Song {
    
    init(dto: SongDTO) {
        self.title = dto.title
        self.artist = dto.artist
        self.albumArtURL = URL(string: dto.artwork)
    }
    
}
