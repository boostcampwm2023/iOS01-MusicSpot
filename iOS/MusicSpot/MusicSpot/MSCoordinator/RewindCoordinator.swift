//
//  RewindCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class RewindCoordinator: Coordinator {
    
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
        let rewindViewController = RewindViewController()
        rewindViewController.delegate = self
        self.navigationController.pushViewController(rewindViewController, animated: true)
    }
    
}

// MARK: - RewindViewController

extension RewindCoordinator: RewindViewControllerDelegate {
    
    func navigateToHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }
    
}

// MARK: - HomeMap Coordinator

extension RewindCoordinator: HomeMapCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
}
