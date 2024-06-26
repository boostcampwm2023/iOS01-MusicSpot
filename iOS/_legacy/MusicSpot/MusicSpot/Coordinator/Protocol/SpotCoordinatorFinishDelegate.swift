//
//  SpotCoordinatorFinishDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 2024.01.11.
//

import Foundation

import MSDomain

protocol SpotCoordinatorFinishDelegate: AnyObject {
    func shouldFinish(childCoordinator: Coordinator, with spot: Spot?, photoData: Data?)
}
