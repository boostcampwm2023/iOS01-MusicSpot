//
//  RecordingJourney.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct RecordingJourney: Identifiable {
    
    // MARK: - Properties
    
    public let id: String
    public let startTimestamp: Date
    public let spots: [Spot]
    public let coordinates: [Coordinate]
    
    // MARK: - Initializer
    
    public init(id: String,
                startTimestamp: Date,
                spots: [Spot],
                coordinates: [Coordinate]) {
        self.id = id
        self.startTimestamp = startTimestamp
        self.spots = spots
        self.coordinates = coordinates
    }
    
}

// MARK: - Hashable

extension RecordingJourney: Hashable {
    
    public static func == (lhs: RecordingJourney, rhs: RecordingJourney) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}
