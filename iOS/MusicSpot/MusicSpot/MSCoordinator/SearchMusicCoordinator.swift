//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

final class SearchMusicCoordinator: Coordinator {
    
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
        let searchMusicViewController = SearchMusicViewController()
        searchMusicViewController.delegate = self
        self.navigationController.pushViewController(searchMusicViewController, animated: true)
    }
    
}

// MARK: - SearchMusicViewController

extension SearchMusicCoordinator: SearchMusicViewControllerDelegate {
    
    func navigateToHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }
    
    func navigateToSaveJourney() {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start()
    }
    
}

// MARK: - App Coordinator

extension SearchMusicCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
