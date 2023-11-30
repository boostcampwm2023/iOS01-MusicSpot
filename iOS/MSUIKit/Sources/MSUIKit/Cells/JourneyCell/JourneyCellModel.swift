//
//  JourneyCellModel.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Foundation

public struct JourneyCellModel: Hashable {
    
    public struct Song {
        let artist: String
        let title: String
    }
    
    // MARK: - Properties
    
    let id: UUID
    let location: String
    let date: Date
    let song: Song
    
    // MARK: - Initializer
    
    public init(id: UUID = UUID(),
                location: String,
                date: Date,
                songTitle: String,
                songArtist: String) {
        self.id = id
        self.location = location
        self.date = date
        self.song = Song(artist: songArtist, title: songTitle)
    }
    
}

// MARK: - Hashable

extension JourneyCellModel {
    
    public static func == (lhs: JourneyCellModel, rhs: JourneyCellModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
