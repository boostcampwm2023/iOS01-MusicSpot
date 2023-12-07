//
//  RewindJourneyCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSData
import RewindJourney

final class RewindJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        let repository = SpotRepositoryImplementation()
        let viewModel = RewindJourneyViewModel(repository: repository)
        let rewindJourneyViewController = RewindJourneyViewController(viewModel: viewModel)
        rewindJourneyViewController.navigationDelegate = self
        self.navigationController.pushViewController(rewindJourneyViewController, animated: true)
    }
    
}

// MARK: - RewindJourney Navigation

extension RewindJourneyCoordinator: RewindJourneyNavigationDelegate {
    
    func popToHomeMap() {
        self.popToHome(from: self)
    }
    
}

// MARK: - HomeMap Coordinator

extension RewindJourneyCoordinator: HomeCoordinatorDelegate {
    
    func popToHome(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHome(from: self)
    }
    
}
