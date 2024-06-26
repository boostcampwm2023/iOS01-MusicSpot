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

extension Coordinate: Codable {
    enum CodingKeys: String, CodingKey {
        case x
        case y
    }

    public init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.x = try container.decode(Double.self, forKey: .x)
        self.y = try container.decode(Double.self, forKey: .y)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
    }
}
