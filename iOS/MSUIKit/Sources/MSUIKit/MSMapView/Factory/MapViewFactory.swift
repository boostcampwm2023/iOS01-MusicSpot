//
//  MapViewFactory.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.02.05.
//

import UIKit
import MapKit

import NMapsMap

enum MapViewFactory {
    
    static func make(_ provider: MapProvider) -> MSMapRenderingView {
        switch provider {
        case .apple:
            return MKMapView()
        case .naver:
            return NMFMapView()
        }
    }
    
}
