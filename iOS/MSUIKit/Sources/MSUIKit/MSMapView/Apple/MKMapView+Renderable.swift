//
//  MKMapView+Renderable.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.29.
//

import MapKit

extension MKMapView: MSMapRenderable {
    
    public func drawNewLocation(_ newLocation: CLLocation) {
        print(newLocation)
    }
    
    public func drawNewLocation(_ newLocation: CLLocation, on overlay: JourneyPath) {
        let (isLocationAdded, isBoundingRectChanged) = overlay.addLocation(newLocation)
        
        if isLocationAdded {
            let zoomScale = self.bounds.size.width / self.visibleMapRect.size.width
            let lineWidth = MKRoadWidthAtZoomScale(zoomScale)
            let pathBounds = overlay.pathBounds.insetBy(dx: -lineWidth, dy: -lineWidth)
            
            
        }
        
        if isBoundingRectChanged {
            
        }
        
        // 시작 점일 경우 현재 위치로 카메라 이동
        if overlay.pathLocations.count == 1 {
            let region = MKCoordinateRegion(center: newLocation.coordinate,
                                            latitudinalMeters: 1_000,
                                            longitudinalMeters: 1_000)
            self.setRegion(region, animated: true)
            self.setUserTrackingMode(.followWithHeading, animated: true)
        }
    }
    
}
