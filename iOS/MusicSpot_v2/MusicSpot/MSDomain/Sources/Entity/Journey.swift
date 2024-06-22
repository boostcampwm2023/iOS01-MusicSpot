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
    public let title: String?
    public let date: Timestamp
    public let spots: [Spot]
    public let coordinates: [Coordinate]
    public let playlist: [Music]
    public let isTraveling: Bool

    // MARK: - Initializer

    public init(id: String,
                title: String?,
                date: Timestamp,
                coordinates: [Coordinate],
                spots: [Spot],
                playlist: [Music],
                isTraveling: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.spots = spots
        self.coordinates = coordinates
        self.playlist = playlist
        self.isTraveling = isTraveling
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

// MARK: - Sample

extension Journey {
    public static let sample = Journey(
        id: UUID().uuidString,
        title: "Sample",
        date: Timestamp(start: .now),
        coordinates: [],
        spots: [],
        playlist: [],
        isTraveling: false
    )
}

// MARK: - String Convertible

extension Journey: CustomStringConvertible {
    public var description: String {
        return """
        Journey
        - title: \(self.title ?? "")
        - state: \(self.isTraveling ? "🏃‍♂️ Traveling" : "😴 Finished")
        - date:
          - start: \(self.date.start)
          - end: \(self.date.end ?? .distantFuture)
        """
    }
}
