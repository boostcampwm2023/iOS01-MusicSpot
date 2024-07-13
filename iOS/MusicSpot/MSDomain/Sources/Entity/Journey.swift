//
//  Journey.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

// MARK: - Journey

public struct Journey: Identifiable {

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        id: String,
        title: String?,
        date: Timestamp,
        coordinates: [Coordinate],
        spots: [Spot],
        playlist: [Music],
        isTraveling: Bool)
    {
        self.id = id
        self.title = title
        self.date = date
        self.spots = spots
        self.coordinates = coordinates
        self.playlist = playlist
        self.isTraveling = isTraveling
    }

    // MARK: Public

    // MARK: - Properties

    public let id: String
    public private(set) var title: String?
    public private(set) var date: Timestamp
    public private(set) var spots: [Spot]
    public private(set) var coordinates: [Coordinate]
    public private(set) var playlist: [Music]
    public private(set) var isTraveling: Bool

}

// MARK: - Mutating Functions

extension Journey {
    public mutating func appendCoordinates(_ coordinates: [Coordinate]) {
        self.coordinates = self.coordinates + coordinates
    }

    public mutating func finish() {
        date.end = .now
        isTraveling = false
    }
}

// MARK: Hashable

extension Journey: Hashable {
    public static func == (lhs: Journey, rhs: Journey) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
        isTraveling: false)
}

// MARK: CustomStringConvertible

extension Journey: CustomStringConvertible {
    public var description: String {
        """
        Journey
        - title: \(title ?? "")
        - state: \(isTraveling ? "🏃‍♂️ Traveling" : "😴 Finished")
        - date:
          - start: \(date.start)
          - end: \(date.end ?? .distantFuture)
        """
    }
}
