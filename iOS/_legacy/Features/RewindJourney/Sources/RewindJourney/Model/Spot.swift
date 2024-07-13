//
//  Spot.swift
//  RewindJourney
//
//  Created by 전민건 on 12/6/23.
//

import Foundation

import MSData

struct Spot {
    let photoURL: URL
}

extension Spot {
    init(dto: SpotDTO) {
        self.photoURL = dto.photoURL
    }
}
