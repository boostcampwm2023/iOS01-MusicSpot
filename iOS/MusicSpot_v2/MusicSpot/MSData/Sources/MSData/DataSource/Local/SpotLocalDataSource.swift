//
//  SpotLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/18/24.
//

import Foundation
import SwiftData

import Entity

@Model
final class SpotLocalDataSource: EntityConvertible {
    typealias Entity = Spot
    
    // MARK: - Relationships
    
    var journey: JourneyLocalDataSource?
    
    // MARK: - Properties
    
    var coordinate: CoordinateLocalDataSource
    var timestamp: Date
    @Relationship(deleteRule: .cascade, inverse: \PhotoLocalDataSource.spot)
    var photos: [PhotoLocalDataSource] = []
    
    // MARK: - Entity Convertible
    
    public init(from entity: Spot) {
        self.coordinate = CoordinateLocalDataSource(from: entity.coordinate)
        self.timestamp = entity.timestamp
        self.photos = entity.photoURLs.map { PhotoLocalDataSource(from: $0) }
    }
    
    public func toEntity() -> Spot {
        return Spot(
            coordinate: self.coordinate.toEntity(),
            timestamp: self.timestamp,
            photoURLs: self.photos.map { $0.toEntity() }
        )
    }
    
}
