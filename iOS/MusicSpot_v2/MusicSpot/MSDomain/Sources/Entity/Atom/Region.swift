//
//  Region.swift
//  Entity
//
//  Created by 이창준 on 5/23/24.
//

import Foundation

/**
 2개의 점(Coordinate)로 이루어진 사각형의 지역을 나타냅니다.
 좌측 하단의 점과 그 반대편인 우측 상단의 점을 기준으로 사각형을 표한힙니다.
 */
public struct Region {
    
    // MARK: - Properties
    
    public let minCoordinate: Coordinate
    public let maxCoordinate: Coordinate
    
    public var width: Double {
        return abs(self.minCoordinate.longitude - self.maxCoordinate.longitude)
    }
    
    public var height: Double {
        return abs(self.minCoordinate.latitude - self.maxCoordinate.latitude)
    }
    
    // MARK: - Initializer
    
    public init(minCoordinate: Coordinate, maxCoordinate: Coordinate) {
        self.minCoordinate = minCoordinate
        self.maxCoordinate = maxCoordinate
    }
    
    public init(x1: Double, x2: Double, y1: Double, y2: Double) {
        let minLatitude = min(y1, y2)
        let maxLatitude = max(y1, y2)
        let minLongitude = min(x1, x2)
        let maxLongitude = max(x1, x2)
        
        self.minCoordinate = Coordinate(latitude: minLatitude, longitude: minLongitude)
        self.maxCoordinate = Coordinate(latitude: maxLatitude, longitude: maxLongitude)
    }
    
    public init(minCoordinate: Coordinate, width: Double, height: Double) {
        self.minCoordinate = minCoordinate
        self.maxCoordinate = Coordinate(
            latitude: minCoordinate.latitude + height,
            longitude: minCoordinate.longitude + width
        )
    }
    
}
