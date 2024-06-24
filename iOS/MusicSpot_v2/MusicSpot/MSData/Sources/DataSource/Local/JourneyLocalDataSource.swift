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

    init(title: String, startDate: Date = .now, isTraveling: Bool = true) {
        self.title = title
        self.startDate = startDate
        self.isTraveling = isTraveling
    }

    // MARK: - Entity Convertible

    public init(from entity: Journey) {
        self.title = entity.title ?? ""
        self.startDate = entity.date.start
        self.endDate = entity.date.end
        self.isTraveling = entity.isTraveling
    }

    public func toEntity() -> Journey {
        return Journey(
            id: "",
            title: self.title,
            date: (start: self.startDate, end: self.endDate),
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
