//
//  DTOConvertor.swift
//  NavigateMap
//
//  Created by 윤동주 on 12/3/23.
//

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.id = dto.id
        self.title = dto.song.title
        self.date = dto.metaData.date
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.coordinates = dto.coordinates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
        self.song = Song(dto: dto.song)
        self.lineColor = dto.lineColor
    }
    
}

extension Spot {
    
    init(dto: ResponsibleSpotDTO) {
        self.id = dto.id
        self.photoURLs = dto.photoURLs
        self.coordinate = Coordinate(latitude: dto.coordinate[0], longitude: dto.coordinate[1])
    }
    
}

extension Song {
    
    init(dto: SongDTO) {
        self.title = dto.title
        self.artist = dto.artist
    }
    
}
