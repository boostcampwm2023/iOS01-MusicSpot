//
//  SpotNavigationDelegate.swift
//  Spot
//
//  Created by 이창준 on 2023.12.05.
//

import UIKit

import MSDomain

public protocol SpotNavigationDelegate: AnyObject {
    
    func presentPhotos(from viewController: UIViewController)
    func presentSpotSave(using image: UIImage, coordinate: Coordinate)
    func dismissToSpot()
    func popToHome()
    func popToHomeWithSpot(spot: Spot)
    
}
