//
//  SettingCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SettingCoordinatorDelegate: AnyObject {
    func popToHomeMap(coordinator: SettingCoordinator)
}

final class SettingCoordinator: Coordinator, SettingViewControllerDelegate {

    // MARK: - Properties

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var delegate: SettingCoordinatorDelegate?

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Functions

    func start() {
        let settingViewController = SettingViewController()
        settingViewController.delegate = self
        navigationController.pushViewController(settingViewController, animated: true)
    }

    func goHomeMap() {
        delegate?.popToHomeMap(coordinator: self)
    }
}
