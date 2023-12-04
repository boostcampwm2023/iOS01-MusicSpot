//
//  Journey.swift
//  NavigateMap
//
//  Created by 윤동주 on 12/3/23.
//

import Foundation

public struct Journey: Hashable {
    
    var id: UUID
    var title: String
    var date: Date
    var spots: [Spot]
    var coordinates: [Coordinate]
    var song: Song
    var lineColor: String
    
    init(id: UUID,
         title: String,
         date: Date,
         spots:[Spot],
         coordinates: [Coordinate],
         song: Song, 
         lineColor: String) {
        self.id = id
        self.title = title
        self.date = date
        self.spots = spots
        self.coordinates = coordinates
        self.song = song
        self.lineColor = lineColor
    }
    
}

// MARK: - Hashable

extension Journey {
    
    public static func == (lhs: Journey, rhs: Journey) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
