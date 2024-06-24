//
//  JourneyLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
public final class JourneyLocalDataSource: EntityConvertible {
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

    // MARK: - Initializer

    init(journeyID: String, title: String, startDate: Date = .now, isTraveling: Bool = true) {
        self.journeyID = journeyID
        self.title = title
        self.startDate = startDate
        self.isTraveling = isTraveling
    }

    // MARK: - Entity Convertible

    public init(from entity: Journey) {
        self.journeyID = entity.id
        self.title = entity.title ?? ""
        self.startDate = entity.date.start
        self.endDate = entity.date.end
        self.isTraveling = entity.isTraveling
    }

    public func toEntity() -> Journey {
        return Journey(
            id: self.journeyID,
            title: self.title,
            date: Timestamp(start: self.startDate, end: self.endDate),
            coordinates: self.coordinates,
            spots: self.spots.map { $0.toEntity() },
            playlist: self.playlist.map { $0.toEntity() },
            isTraveling: self.isTraveling
        )
    }

    public func isEqual(to entity: Journey) -> Bool {
        return self.journeyID == entity.id
    }
}

// MARK: - Updatable

extension JourneyLocalDataSource: Updatable {
    package func update(to dataSource: JourneyLocalDataSource) {
        self.title = dataSource.title
        self.startDate = dataSource.startDate
        self.endDate = dataSource.endDate
        self.isTraveling = dataSource.isTraveling
        self.coordinates = dataSource.coordinates
        self.spots = dataSource.spots
        self.playlist = dataSource.playlist
    }
}
