//
//  HomeMapCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol HomeMapCoordinatorDelegate {
    func navigateToSpot(coordinator: HomeMapCoordinator)
    func navigateToRewind(coordinator: HomeMapCoordinator)
    func navigateToSetting(coordinator: HomeMapCoordinator)
}

class HomeMapCoordinator: Coordinator, HomeMapViewControllerDelegate {
    
    // MARK: - Properties

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var delegate: HomeMapCoordinatorDelegate?
    
    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions

    func start() {
        let homeMapViewController = HomeMapViewController()
        homeMapViewController.delegate = self
        navigationController.pushViewController(homeMapViewController, animated: true)
    }
    
    func goSpot() {
        delegate?.navigateToSpot(coordinator: self)
    }
    
    func goRewind() {
        delegate?.navigateToRewind(coordinator: self)
    }
    
    func goSetting() {
        delegate?.navigateToSetting(coordinator: self)
    }
}
