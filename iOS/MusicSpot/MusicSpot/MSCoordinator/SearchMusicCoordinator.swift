//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

final class SearchMusicCoordinator: Coordinator, SearchMusicViewControllerDelegate {

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

    func goHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }

    func goSaveJourney() {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: navigationController)
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start()
    }
    
}

extension SearchMusicCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.start()
    }
    
}
