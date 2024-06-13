//
//  Coordinate.swift
//  Entity
//
//  Created by 이창준 on 6/13/24.
//

import MapKit

public typealias Coordinate = MKMapPoint

extension Coordinate {
    var latitude: Double {
        coordinate.latitude
    }

    var longitude: Double {
        coordinate.longitude
    }
}

extension Coordinate: @retroactive Equatable {
    public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}
