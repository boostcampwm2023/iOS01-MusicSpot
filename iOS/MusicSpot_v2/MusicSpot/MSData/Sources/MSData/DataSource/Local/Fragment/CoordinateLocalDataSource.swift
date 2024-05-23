//
//  CoordinateLocalDataSource.swift
//  MSData
//
//  Created by 이창준 on 5/22/24.
//

import SwiftData

import Entity

@Model
final class CoordinateLocalDataSource: EntityConvertible {
    typealias Entity = Coordinate
    
    // MARK: - Properties
    
    var latitude: Double
    var longitude: Double
    
    // MARK: - Initializer
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: - Entity Convertible
    
    init(from entity: Coordinate) {
        self.latitude = entity.latitude
        self.longitude = entity.longitude
    }
    
    func toEntity() -> Coordinate {
        return Coordinate(latitude: self.latitude, longitude: self.longitude)
    }
    
}
