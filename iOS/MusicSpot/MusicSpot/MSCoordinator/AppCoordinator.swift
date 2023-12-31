//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol AppCoordinatorDelegate: AnyObject {
    
    func popToHomeMap(from coordinator: Coordinator)
    func popToSearchMusic(from coordinator: Coordinator)
    
}

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - From: HomeMap
    
    func start() {
        let homeMapCoordinator = HomeCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(homeMapCoordinator)
        homeMapCoordinator.start()
    }
    
}
