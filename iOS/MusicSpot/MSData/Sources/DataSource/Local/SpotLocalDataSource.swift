//
//  SpotLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class SpotLocalDataSource: EntityConvertible {

    // MARK: Lifecycle

    // MARK: - Entity Convertible

    public init(from entity: Spot) {
        spotID = entity.id
        coordinate = entity.coordinate
        timestamp = entity.timestamp
        photos = entity.photoURLs.map { PhotoLocalDataSource(from: $0) }
    }

    // MARK: Public

    public typealias Entity = Spot

    // MARK: - Relationships

    public var journey: JourneyLocalDataSource?

    // MARK: - Properties

    public let spotID: String
    public var coordinate: Coordinate
    public var timestamp: Date
    @Relationship(deleteRule: .cascade, inverse: \PhotoLocalDataSource.spot)
    public var photos: [PhotoLocalDataSource] = []

    public func toEntity() -> Spot {
        Spot(
            id: spotID,
            coordinate: coordinate,
            timestamp: timestamp,
            photoURLs: photos.map { $0.toEntity() })
    }

    public func isEqual(to entity: Spot) -> Bool {
        spotID == entity.id
    }
}
