//
//  Coordinate.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct Coordinate {
    
    // MARK: - Properties
    
    public let latitude: Double
    public let longitude: Double
    
    // MARK: - Initializer
    
    public init(latitude: Double,
                longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

// MARK: - Hashable

extension Coordinate: Hashable { }
