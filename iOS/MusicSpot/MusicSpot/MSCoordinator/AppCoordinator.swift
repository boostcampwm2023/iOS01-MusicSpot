//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol AppCoordinatorDelegate {
    
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
        let homeMapCoordinator = HomeMapCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(homeMapCoordinator)
        homeMapCoordinator.start()
    }
    
}

// MARK: - App Coordinator

extension AppCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.start()
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popToRootViewController(animated: true)
    }
    
}
