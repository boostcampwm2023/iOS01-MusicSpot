//
//  JourneyLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

@Model
final class JourneyLocalDataSource {
    
    // MARK: - Properties
    
    var title: String
    var startDate: Date
    var endDate: Date?
    
    var coordinates: [Coordinate] = []
    @Relationship(deleteRule: .cascade, inverse: \SpotLocalDataSource.journey)
    var spots: [SpotLocalDataSource] = []
    @Relationship(deleteRule: .cascade, inverse: \MusicLocalDataSource.journey)
    var music: [MusicLocalDataSource] = []
    
    // MARK: - Initializer
    
    init(title: String, startDate: Date = .now) {
        self.title = title
        self.startDate = startDate
    }
    
}
