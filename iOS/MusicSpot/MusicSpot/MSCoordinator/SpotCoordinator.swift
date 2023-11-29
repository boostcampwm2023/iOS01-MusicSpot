//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SpotCoordinatorDelegate {
    func navigateToHomeMap(coordinator: SpotCoordinator)
    func navigateToSearchMusic(coordinator: SpotCoordinator)
}

class SpotCoordinator: Coordinator, SpotViewControllerDelegate {
    // MARK: - Properties

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var delegate: SpotCoordinatorDelegate?
    
    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions

    func start() {
        let spotViewController = SpotViewController()
        spotViewController.delegate = self
        navigationController.pushViewController(spotViewController, animated: true)
    }
    
    func goHomeMap() {
        delegate?.navigateToHomeMap(coordinator: self)
    }
    
    func goSearchMusic() {
        delegate?.navigateToSearchMusic(coordinator: self)
    }
    
}
