//
//  JourneyPath.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.02.01.
//

import Foundation
import MapKit

public final class JourneyPath: NSObject, MKOverlay {
    
    // MARK: - Data
    
    private struct JourneyPathData {
        var locations: [CLLocation]
        var bounds: MKMapRect
        
        init(locations: [CLLocation] = [], bounds: MKMapRect = .world) {
            self.locations = locations
            self.bounds = bounds
        }
    }
    
    // MARK: - Properties
    
    public let boundingMapRect: MKMapRect = .world
    /// From `MKAnnotation`, for areas this should return the centroid of the area.
    public var coordinate = CLLocationCoordinate2D(latitude: .zero, longitude: .zero)
    
    private var journeyPathData = JourneyPathData()
    
    // MARK: - Functions
    
    func addLocation(_ newLocation: CLLocation) -> (isLocationAdded: Bool, isBoundingRectChanged: Bool) {
        var journeyPathData = self.journeyPathData
        
        guard self.isNewLocationViable(newLocation, journeyPathData: journeyPathData) else {
            let isLocationAdded = false
            let isBoundingRectChanged = false
            return (isLocationAdded, isBoundingRectChanged)
        }
        
        defer { self.journeyPathData = journeyPathData }
        var lastLocation = journeyPathData.locations.last
        
        // Data가 비어있다면 (첫 기록 값이라면), area의 중앙 값을 의미하는 `coordinate` 프로퍼티 값을 설정합니다.
        if journeyPathData.locations.isEmpty {
            self.coordinate = newLocation.coordinate
            
            // Origin
            let origin = MKMapPoint(newLocation.coordinate)
            
            // Size
            // 위도가 높아질수록 같은 거리에 Point들이 증가하는 현상을 고려한 과정
            let mapPointsForOneKilometer = 1_000 * MKMapPointsPerMeterAtLatitude(newLocation.coordinate.latitude)
            let size = MKMapSize(width: mapPointsForOneKilometer, height: mapPointsForOneKilometer)
            
            journeyPathData.bounds = MKMapRect(origin: origin, size: size)
            
            // 이후 동작에서 `lastLocation`이 nil 값이 아니게 만들기 위해 값을 할당
            lastLocation = newLocation
        }
        
        journeyPathData.locations.append(newLocation)
        
        let size = MKMapSize(width: .zero, height: .zero)
        let lastOrigin = MKMapPoint(lastLocation!.coordinate)
        let lastRect = MKMapRect(origin: lastOrigin, size: size)
        let newOrigin = MKMapPoint(newLocation.coordinate)
        let newRect = MKMapRect(origin: newOrigin, size: size)
        let updatedRect = newRect.union(lastRect)
        
        let isLocationAdded = true
        var isBoundingRectChanged = false
        
        // 새로운 Rect를 포함한 `rect` 값이 이전 `rect` 내부에 완전히 포함되지 않았다면 (확장이 필요하다면),
        // JourneyPath의 `bounds` 값을 새로운 값이 포함되도록 업데이트
        if !journeyPathData.bounds.contains(updatedRect) {
            journeyPathData.bounds = self.updateBoundingRect(lastRect: journeyPathData.bounds, newRect: updatedRect)
            isBoundingRectChanged = true
        }
        
        return (isLocationAdded, isBoundingRectChanged)
    }
    
    /// 이전 Rect에 새로운 Rect를 합친 새로운 Rect를 반환
    private func updateBoundingRect(lastRect: MKMapRect, newRect: MKMapRect) -> MKMapRect {
        var enlargingBounds = lastRect.union(newRect)
        
        let paddingPointsForOneKilometer = 1_000 * MKMapPointsPerMeterAtLatitude(newRect.origin.coordinate.latitude)
        
        if newRect.minX < lastRect.minX {
            enlargingBounds.origin.x -= paddingPointsForOneKilometer
            enlargingBounds.size.width += paddingPointsForOneKilometer
        }
        
        if newRect.maxX > lastRect.maxX {
            enlargingBounds.origin.x += paddingPointsForOneKilometer
            enlargingBounds.size.width += paddingPointsForOneKilometer
        }
        
        if newRect.minY < lastRect.minY {
            enlargingBounds.origin.y -= paddingPointsForOneKilometer
            enlargingBounds.size.height += paddingPointsForOneKilometer
        }
        
        if newRect.maxY > lastRect.maxY {
            enlargingBounds.origin.y += paddingPointsForOneKilometer
            enlargingBounds.size.height += paddingPointsForOneKilometer
        }
        
        return enlargingBounds
    }
    
    /// 새로운 Location이 이전 데이터에 추가될 수 있는 값인지 확인합니다.
    /// - Returns: `newLocation`의 적합 여부
    private func isNewLocationViable(_ newLocation: CLLocation, journeyPathData: JourneyPathData) -> Bool {
        // TODO: 적합성 필터
        return true
    }
    
}
