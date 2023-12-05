//
//  SpotNavigationDelegate.swift
//  Spot
//
//  Created by 이창준 on 2023.12.05.
//

import UIKit

public protocol SpotNavigationDelegate: AnyObject {
    
    func presentPhotos(from viewController: UIViewController)
    func presentSpotSave(using image: UIImage)
    func dismissToSpot()
    func navigateToSelectSong()
    
}
