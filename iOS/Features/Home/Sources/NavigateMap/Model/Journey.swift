//
//  Journey.swift
//  Home
//
//  Created by 윤동주 on 12/5/23.
//

import Foundation
import MSDomain

struct Journey: Hashable {
    let id: String?
    let title: String
    let coordinates: [Coordinate]
    let spots: [Spot]

    // MARK: - Initializer
    
    init(id: String, title: String, coordinates: [Coordinate], spots: [Spot]) {
        self.id = id
        self.title = title
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
