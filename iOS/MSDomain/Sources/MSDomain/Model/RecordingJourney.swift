//
//  RecordingJourney.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

@dynamicMemberLookup
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
    
    public init(_ journey: Journey) {
        self.id = journey.id
        self.startTimestamp = journey.date.start
        self.spots = journey.spots
        self.coordinates = journey.coordinates
    }
    
    // MARK: - Subscript
    
    subscript<T>(dynamicMember keyPath: KeyPath<RecordingJourney, T>) -> T {
        return self[keyPath: keyPath]
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

// MARK: - Custom String

extension RecordingJourney: CustomStringConvertible {
    
    public var description: String {
        return """
        ID: \(self.id)
        Starting Time: \(self.startTimestamp)
        Number of Spots: \(self.spots.count)
        Number of Coordinates: \(self.coordinates.count)
        """
    }
    
}
