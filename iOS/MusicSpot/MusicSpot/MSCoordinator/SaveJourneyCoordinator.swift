//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol SaveJourneyCoordinatorDelegate: AnyObject {
    func popToHomeMap(coordinator: SaveJourneyCoordinator)
    func popToSearchMusic(coordinator: SaveJourneyCoordinator)
}

final class SaveJourneyCoordinator: Coordinator, SaveJourneyViewControllerDelegate {

    // MARK: - Properties

    var navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    var delegate: SaveJourneyCoordinatorDelegate?

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Functions

    func start() {
        let saveJourneyViewController = SaveJourneyViewController()
        saveJourneyViewController.delegate = self
        navigationController.pushViewController(saveJourneyViewController, animated: true)
    }

    func goHomeMap() {
        delegate?.popToHomeMap(coordinator: self)
    }

    func goSearchMusic() {
        delegate?.popToSearchMusic(coordinator: self)
    }
}
