//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - From: HomeMap
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
}
