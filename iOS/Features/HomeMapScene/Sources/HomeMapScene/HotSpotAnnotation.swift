//
//  HotSpotAnnotation.swift
//
//
//  Created by 윤동주 on 11/23/23.
//

import Foundation
import CoreLocation
import MapKit

struct Coordinate {
    var latitude: String
    var longitude: String
}

class HotSpot: NSObject, MKAnnotation {

    // MARK: - Properties

    var id: UUID
    var coordinate: CLLocationCoordinate2D
    var timestamp: String
    var photo: Data

    // MARK: - Life Cycle

    init(id: UUID,
         coordinate: CLLocationCoordinate2D,
         timestamp: String,
         photo: Data) {
        self.id = id
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photo = photo
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
