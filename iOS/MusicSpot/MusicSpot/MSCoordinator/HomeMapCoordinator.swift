//
//  HomeMapCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class HomeMapCoordinator: Coordinator, HomeMapViewControllerDelegate {

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

    func goSpot() {
        let spotCoordinator = SpotCoordinator(navigationController: navigationController)
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }

    func goRewind() {
        let rewindCoordinator = RewindCoordinator(navigationController: navigationController)
        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }

    func goSetting() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
}

extension HomeMapCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.start()
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToSearchMusic(from: self)
    }
}
