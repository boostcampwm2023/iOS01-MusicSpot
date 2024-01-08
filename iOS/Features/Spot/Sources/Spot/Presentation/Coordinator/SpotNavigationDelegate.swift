//
//  SpotNavigationDelegate.swift
//  Spot
//
//  Created by 이창준 on 2023.12.05.
//

import UIKit

import MSDomain

public protocol SpotNavigationDelegate: AnyObject {
    
    func presentPhotoLibrary(from viewController: UIViewController)
    func presentSaveSpot(using image: UIImage, coordinate: Coordinate)
    func dismissToSpot()
    func popToHome(spot: Spot?)
    
}

extension SpotNavigationDelegate {
    
    public func popToHome(spot: Spot? = nil) {
        self.popToHome(spot: nil)
    }
    
}
