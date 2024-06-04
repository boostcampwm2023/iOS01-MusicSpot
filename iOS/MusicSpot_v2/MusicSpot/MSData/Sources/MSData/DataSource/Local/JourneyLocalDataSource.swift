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
final class JourneyLocalDataSource: EntityConvertible {
    typealias Entity = Journey

    // MARK: - Properties

    var title: String
    var startDate: Date
    var endDate: Date?
    var isTraveling: Bool

    var coordinates: [Coordinate] = []
    @Relationship(deleteRule: .cascade, inverse: \SpotLocalDataSource.journey)
    var spots: [SpotLocalDataSource] = []
    @Relationship(deleteRule: .cascade, inverse: \MusicLocalDataSource.journey)
    var playlist: [MusicLocalDataSource] = []

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
}
