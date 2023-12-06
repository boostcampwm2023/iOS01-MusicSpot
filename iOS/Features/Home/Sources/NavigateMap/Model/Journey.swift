//
//  Journey.swift
//  Home
//
//  Created by 윤동주 on 12/5/23.
//

import Foundation

struct Journey: Hashable {
    let id: UUID
    let location: String
    let coordinates: [Coordinate]
    let spots: [Spot]

    // MARK: - Initializer
    
    init(id: UUID = UUID(), location: String, coordinates: [Coordinate], spots: [Spot]) {
        self.id = id
        self.location = location
        self.coordinates = coordinates
        self.spots = spots
    }
    
}

// MARK: - Hashable

extension Journey {
    
    static func == (lhs: Journey, rhs: Journey) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
