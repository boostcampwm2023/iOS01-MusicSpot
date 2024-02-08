//
//  MSMapRenderable.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.29.
//

import CoreLocation
import UIKit

typealias MSMapRenderingView = (UIView & MSMapRenderable)

public protocol MSMapRenderable: AnyObject {
    
    // MARK: - Polyline
    
    func drawNewLocation(_ newLocation: CLLocation)
    
}
