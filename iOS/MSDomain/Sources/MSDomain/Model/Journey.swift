//
//  Journey.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct Journey: Identifiable {
    
    // MARK: - Properties
    
    public let id: String
    public let title: String
    public let date: (start: Date, end: Date)
    public let spots: [Spot]
    public let coordinates: [Coordinate]
    public let music: Music
    
    // MARK: - Initializer
    
    public init(id: String,
                title: String,
                date: (start: Date, end: Date),
                spots: [Spot],
                coordinates: [Coordinate],
                music: Music) {
        self.id = id
        self.title = title
        self.date = date
        self.spots = spots
        self.coordinates = coordinates
        self.music = music
    }
    
}

// MARK: - Hashable

extension Journey: Hashable {
    
    public static func == (lhs: Journey, rhs: Journey) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
}

// MARK: - String Convertible

extension Journey: CustomStringConvertible {
    
    public var description: String {
        return """
        Journey
        - title: \(self.title)
        - date:
          - start: \(self.date.start)
          - end: \(self.date.end)
        """
    }
    
}
