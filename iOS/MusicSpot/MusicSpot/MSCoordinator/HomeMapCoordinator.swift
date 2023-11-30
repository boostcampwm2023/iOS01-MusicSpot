//
//  HomeMapCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol HomeMapCoordinatorDelegate: AnyObject {
    
    func popToHomeMap(from coordinator: Coordinator)
    
}

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

// MARK: - NavigateMapViewController

extension HomeMapCoordinator: HomeMapViewControllerDelegate {
    
    func navigateToSpot() {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.delegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }
    
    func navigateToSearchMusic() {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: self.navigationController)
        searchMusicCoordinator.delegate = self
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
    
    func navigateToRewind() {
        let rewindCoordinator = RewindCoordinator(navigationController: self.navigationController)
        rewindCoordinator.delegate = self
        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }
    
    func navigateToSetting() {
        let settingCoordinator = SettingCoordinator(navigationController: self.navigationController)
        settingCoordinator.delegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
}

// MARK: - HomeMap Coordinator

extension HomeMapCoordinator: HomeMapCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
