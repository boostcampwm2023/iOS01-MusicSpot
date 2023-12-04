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
        self.location = dto.location
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.date = dto.metaData.date
        self.song = Song(dto: dto.song)
    }
    
}

extension Spot {
    
    init(dto: ResponsibleSpotDTO) {
        self.id = dto.id
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
    }
    
}
