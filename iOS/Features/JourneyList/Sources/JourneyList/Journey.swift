//
//  Journey.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Foundation

struct Journey: Hashable, Decodable {
    
    // MARK: - Properties
    
    let id: UUID
    let location: String
    let date: Date
    let spots: [Spot]
    let song: Song
    
    // MARK: - Initializer
    
    init(id: UUID = UUID(), location: String, date: Date, spots: [Spot], song: Song) {
        self.id = id
        self.location = location
        self.date = date
        self.spots = spots
        self.song = song
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
