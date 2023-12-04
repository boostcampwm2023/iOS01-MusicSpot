//
//  Spot.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Foundation

struct Spot: Hashable, Identifiable {
    
    let id: UUID
    let location: Coordinate
    let date: Date
    let photoURL: URL
    
}
