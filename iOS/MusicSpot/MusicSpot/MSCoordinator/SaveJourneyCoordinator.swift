//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol SaveJourneyCoordinatorDelegate {
    func navigateToHomeMap(coordinator: SaveJourneyCoordinator)
    func navigateToSearchMusic(coordinator: SaveJourneyCoordinator)
}

class SaveJourneyCoordinator: Coordinator, SaveJourneyViewControllerDelegate {
    
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
        delegate?.navigateToHomeMap(coordinator: self)
    }
    
    func goSearchMusic() {
        delegate?.navigateToSearchMusic(coordinator: self)
    }
}