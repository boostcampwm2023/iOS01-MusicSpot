//
//  HomeMapCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol HomeMapCoordinatorDelegate: AnyObject {
    func pushToSpot(coordinator: HomeMapCoordinator)
    func pushToRewind(coordinator: HomeMapCoordinator)
    func pushToSetting(coordinator: HomeMapCoordinator)
}

final class HomeMapCoordinator: Coordinator, HomeMapViewControllerDelegate {

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
        delegate?.pushToSpot(coordinator: self)
    }

    func goRewind() {
        delegate?.pushToRewind(coordinator: self)
    }

    func goSetting() {
        delegate?.pushToSetting(coordinator: self)
    }
}
