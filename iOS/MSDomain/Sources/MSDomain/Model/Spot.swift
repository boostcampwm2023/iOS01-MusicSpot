//
//  Spot.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct Spot {
    
    // MARK: - Properties
    
    public let coordinate: Coordinate
    public let timestamp: Date
    public let photoURL: URL
    
    // MARK: - Initializer
    
    public init(coordinate: Coordinate,
                timestamp: Date,
                photoURL: URL) {
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoURL = photoURL
    }
    
}

// MARK: - Hashable

extension Spot: Hashable { }
