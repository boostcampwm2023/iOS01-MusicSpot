//
//  RewindCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol RewindCoordinatorDelegate: AnyObject {
    func navigateToHomeMap(coordinator: RewindCoordinator)
}

final class RewindCoordinator: Coordinator, RewindViewControllerDelegate {

    // MARK: - Properties

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var delegate: RewindCoordinatorDelegate?

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Functions

    func start() {
        let rewindViewController = RewindViewController()
        rewindViewController.delegate = self
        navigationController.pushViewController(rewindViewController, animated: true)
    }

    func goHomeMap() {
        delegate?.navigateToHomeMap(coordinator: self)
    }
}
