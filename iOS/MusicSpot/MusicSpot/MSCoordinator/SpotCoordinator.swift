//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SpotCoordinatorDelegate: AnyObject {
    func popToHomeMap(coordinator: SpotCoordinator)
    func pushToSearchMusic(coordinator: SpotCoordinator)
}

final class SpotCoordinator: Coordinator, SpotViewControllerDelegate {
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
        delegate?.popToHomeMap(coordinator: self)
    }

    func goSearchMusic() {
        delegate?.pushToSearchMusic(coordinator: self)
    }
}
