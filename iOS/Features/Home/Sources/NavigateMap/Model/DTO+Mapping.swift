//
//  File.swift
//  
//
//  Created by 윤동주 on 12/5/23.
//

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.id = dto.id
        self.location = dto.location
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.coordinates = dto.coordinates.map { Coordinate(dto: $0)}
    }
    
}
extension Spot {
    
    init(dto: ResponsibleSpotDTO) {
        self.journeyID = dto.id
        self.photoURL = dto.photoURL
        self.coordinate = Coordinate(dto: dto.coordinate)
    }
    
}

extension Coordinate {
    
    init(dto: CoordinateDTO) {
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
    
}
