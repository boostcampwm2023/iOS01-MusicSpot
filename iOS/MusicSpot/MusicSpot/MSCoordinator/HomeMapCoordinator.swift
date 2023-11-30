//
//  HomeMapCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class HomeMapCoordinator: Coordinator {
    
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
        let homeMapViewController = HomeMapViewController()
        homeMapViewController.delegate = self
        self.navigationController.pushViewController(homeMapViewController, animated: true)
    }
    
}

// MARK: - HomeMapViewController

extension HomeMapCoordinator: HomeMapViewControllerDelegate {
    
    func navigateToSpot() {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }
    
    func navigateToRewind() {
        let rewindCoordinator = RewindCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }
    
    func navigateToSetting() {
        let settingCoordinator = SettingCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
}

// MARK: - App Coordinator

extension HomeMapCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToSearchMusic(from: self)
    }
}
