//
//  JourneyLocalDataSource.swift
//  DataSource
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

// MARK: - JourneyLocalDataSource

@Model
public final class JourneyLocalDataSource: EntityConvertible {

    // MARK: Lifecycle

    // MARK: - Initializer

    init(journeyID: String, title: String, startDate: Date = .now, isTraveling: Bool = true) {
        self.journeyID = journeyID
        self.title = title
        self.startDate = startDate
        self.isTraveling = isTraveling
    }

    // MARK: - Entity Convertible

    public init(from entity: Journey) {
        journeyID = entity.id
        title = entity.title ?? ""
        startDate = entity.date.start
        endDate = entity.date.end
        isTraveling = entity.isTraveling
    }

    // MARK: Public

    public typealias Entity = Journey

    // MARK: - Properties

    public let journeyID: String
    public var title: String
    public var startDate: Date
    public var endDate: Date?
    public var isTraveling: Bool

    public var coordinates: [Coordinate] = []
    @Relationship(deleteRule: .cascade, inverse: \SpotLocalDataSource.journey)
    public var spots: [SpotLocalDataSource] = []
    @Relationship(deleteRule: .cascade, inverse: \MusicLocalDataSource.journey)
    public var playlist: [MusicLocalDataSource] = []

    public func toEntity() -> Journey {
        Journey(
            id: journeyID,
            title: title,
            date: Timestamp(start: startDate, end: endDate),
            coordinates: coordinates,
            spots: spots.map { $0.toEntity() },
            playlist: playlist.map { $0.toEntity() },
            isTraveling: isTraveling)
    }

    public func isEqual(to entity: Journey) -> Bool {
        journeyID == entity.id
    }
}

// MARK: Updatable

extension JourneyLocalDataSource: Updatable {
    package func update(to dataSource: JourneyLocalDataSource) {
        title = dataSource.title
        startDate = dataSource.startDate
        endDate = dataSource.endDate
        isTraveling = dataSource.isTraveling
        coordinates = dataSource.coordinates
        spots = dataSource.spots
        playlist = dataSource.playlist
    }
}
