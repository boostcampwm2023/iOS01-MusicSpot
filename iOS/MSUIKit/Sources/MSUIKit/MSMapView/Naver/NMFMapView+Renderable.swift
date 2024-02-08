//
//  NMFMapView+Renderable.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.29.
//

import NMapsMap

extension NMFMapView: MSMapRenderable {
    
    public func drawNewLocation(_ newLocation: CLLocation) {
        print(newLocation)
    }
    
}
