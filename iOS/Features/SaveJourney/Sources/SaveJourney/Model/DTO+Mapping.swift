//
//  DTO+Mapping.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

import MSData

extension Journey {
    
    init(dto: JourneyDTO) {
        self.location = dto.location
        self.spots = dto.spots.map { Spot(dto: $0) }
        self.date = dto.metaData.date
    }
    
}

extension Spot {
    
    init(dto: ResponsibleSpotDTO) {
        self.photoURLs = dto.photoURLs
    }
    
}
