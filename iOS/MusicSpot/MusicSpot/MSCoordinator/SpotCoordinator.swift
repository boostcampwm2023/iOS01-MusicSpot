//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class SpotCoordinator: Coordinator {
    
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
        let spotViewController = SpotViewController()
        spotViewController.delegate = self
        self.navigationController.pushViewController(spotViewController, animated: true)
    }
    
}

// MARK: - SpotViewController

extension SpotCoordinator: SpotViewControllerDelegate {
    
    func navigateToHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }
    
}

// MARK: - HomeMap Coordinator

extension SpotCoordinator: HomeMapCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
}
