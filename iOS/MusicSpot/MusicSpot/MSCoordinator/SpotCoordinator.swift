//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class SpotCoordinator: Coordinator, SpotViewControllerDelegate {
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

    func goHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }

    func goSearchMusic() {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
}

extension SpotCoordinator: AppCoordinatorDelegate {
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToSearchMusic(from: self)
    }
    
}
