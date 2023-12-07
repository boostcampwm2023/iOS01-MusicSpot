//
//  File.swift
//  
//
//  Created by 윤동주 on 12/5/23.
//

import MSData
import MSDomain

extension Journey {
    
    init(dto: JourneyDTO) {
        self.id = dto.id
        self.title = dto.title
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.coordinates = dto.coordinates.map { Coordinate(dto: $0)}
    }
    
}
extension Spot {
    
    init(dto: SpotDTO) {
        self.journeyID = dto.journeyID
        self.photoURL = dto.photoURL
        self.coordinate = Coordinate(dto: dto.coordinate)
    }
    
}

extension Coordinate {
    
    init(dto: CoordinateDTO) {
        self.init(latitude: dto.latitude, longitude: dto.longitude)
    }
    
}
