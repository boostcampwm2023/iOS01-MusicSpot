//
//  Spot.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct Spot {
    // MARK: - Properties

    public let coordinate: Coordinate
    public let timestamp: Date
    public let photoURLs: [URL]

    // MARK: - Initializer

    public init(coordinate: Coordinate,
                timestamp: Date,
                photoURLs: [URL]) {
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURLs = photoURLs
    }
}

public struct RequestableSpot {
    // MARK: - Properties

    public let journeyID: String
    public let coordinate: Coordinate
    public let timestamp: Date
    public let photoData: Data

    // MARK: - Initializer

    public init(journeyID: String,
                coordinate: Coordinate,
                timestamp: Date,
                photoData: Data) {
        self.journeyID = journeyID
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoData = photoData
    }
}

// MARK: - String Convertible

extension Spot: CustomStringConvertible {
    public var description: String {
        return """
        Coordinate:
          - latitude: \(self.coordinate.latitude)
          - longitude: \(self.coordinate.longitude)
        PhotoURLs
          - x\(self.photoURLs.count)
        Timestamp
          - \(self.timestamp)
        """
    }
}
