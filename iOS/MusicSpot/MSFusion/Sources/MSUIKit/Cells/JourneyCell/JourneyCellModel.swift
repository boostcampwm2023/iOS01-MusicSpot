//
//  JourneyCellModel.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Foundation

// MARK: - JourneyCellModel

public struct JourneyCellModel: Hashable {
    // MARK: - Properties

    let id: UUID
    let location: String
    let date: Date

    // MARK: - Initializer

    public init(
        id: UUID = UUID(),
        location: String,
        date: Date)
    {
        self.id = id
        self.location = location
        self.date = date
    }
}

// MARK: - Hashable

extension JourneyCellModel {
    public static func == (lhs: JourneyCellModel, rhs: JourneyCellModel) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
