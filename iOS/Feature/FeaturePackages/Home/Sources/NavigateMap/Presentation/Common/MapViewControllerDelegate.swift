//
//  MapViewControllerDelegate.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

public protocol MapViewControllerDelegate: AnyObject {
    
    func mapViewControllerDidChangeVisibleRegion(_ mapViewController: MapViewController)
    
}
