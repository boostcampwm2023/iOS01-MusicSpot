//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol SearchMusicCoordinatorDelegate {
    func navigateToHomeMap(coordinator: SearchMusicCoordinator)
    func navigateToSaveJourney(coordinator: SearchMusicCoordinator)
}

class SearchMusicCoordinator: Coordinator, SearchMusicViewControllerDelegate {
    
    // MARK: - Properties

    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var delegate: SearchMusicCoordinatorDelegate?
    
    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions

    func start() {
        let searchMusicViewController = SearchMusicViewController()
        searchMusicViewController.delegate = self
        navigationController.pushViewController(searchMusicViewController, animated: true)
    }
    
    func goHomeMap() {
        delegate?.navigateToHomeMap(coordinator: self)
    }
    
    func goSaveJourney() {
        delegate?.navigateToSaveJourney(coordinator: self)
    }
}
