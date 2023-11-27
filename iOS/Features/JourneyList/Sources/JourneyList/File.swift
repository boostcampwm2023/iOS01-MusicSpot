//
//  File.swift
//  
//
//  Created by 이창준 on 2023.11.27.
//

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.id = dto.id
        self.location = dto.location
        self.date = dto.metaData.date
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.song = Song(dto: dto.song)
    }
    
}

extension Spot {
    
    init(dto: SpotDTO) {
        self.photoURLs = dto.photoURLs
    }
    
}

extension Song {
    
    init(dto: SongDTO) {
        self.title = dto.title
        self.artist = dto.artist
    }
    
}
