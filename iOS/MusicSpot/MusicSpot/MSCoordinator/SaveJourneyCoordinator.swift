//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

final class SaveJourneyCoordinator: Coordinator, SaveJourneyViewControllerDelegate {

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
        let saveJourneyViewController = SaveJourneyViewController()
        saveJourneyViewController.delegate = self
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }

    func goHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }

    func goSearchMusic() {
        self.delegate?.popToSearchMusic(from: self)
    }
    
}

extension SaveJourneyCoordinator: AppCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.delegate?.popToSearchMusic(from: self)
    }
    
}
