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

// MARK: Equatable

extension Coordinate: @retroactive Equatable {
    public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

// MARK: Codable

extension Coordinate: Codable {

    // MARK: Lifecycle

    public init(from decoder: any Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        x = try container.decode(Double.self, forKey: .x)
        y = try container.decode(Double.self, forKey: .y)
    }

    // MARK: Public

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case x
        case y
    }

}
