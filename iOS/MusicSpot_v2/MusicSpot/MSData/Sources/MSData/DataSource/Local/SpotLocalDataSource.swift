//
//  SpotLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import SwiftData

@Model
final class SpotLocalDataSource {
    
    // MARK: - Relationships
    
    var journey: JourneyLocalDataSource?
    
    // MARK: - Properties
    
    @Relationship(deleteRule: .cascade, inverse: \PhotoLocalDataSource.spot)
    var photos: [PhotoLocalDataSource] = []
    
    // MARK: - Initializer
    
    init() { }
    
}
