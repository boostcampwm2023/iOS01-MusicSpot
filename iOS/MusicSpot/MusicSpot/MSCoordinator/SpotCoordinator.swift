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
    
    var delegate: AppCoordinatorDelegate?
    
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
    
    func navigateToSearchMusic() {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
    
}

// MARK: - App Coordinator

extension SpotCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToSearchMusic(from: self)
    }
    
}
