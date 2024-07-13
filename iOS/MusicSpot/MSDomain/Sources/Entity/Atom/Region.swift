//
//  Region.swift
//  Entity
//
//  Created by 이창준 on 6/13/24.
//

import MapKit

public typealias Region = MKMapRect

extension Region {
    public func containsAny(of points: [MKMapPoint]) -> Bool {
        points.contains { self.contains($0) }
    }
}
