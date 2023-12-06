//
//  DTO+Mapping.swift
//  JourneyList
//
//  Created by 이창준 on 2023.11.27.
//

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.id = dto.id
        self.title = dto.title
        // TODO: API 수정 후 적용
        self.date = .now
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.song = Song(dto: dto.song)
    }
    
}

extension Spot {
    
    init(dto: SpotDTO) {
        self.photoURL = dto.photoURL
    }
    
}

extension Song {
    
    init(dto: SongDTO) {
        self.title = dto.title
        self.artist = dto.artist
    }
    
}
