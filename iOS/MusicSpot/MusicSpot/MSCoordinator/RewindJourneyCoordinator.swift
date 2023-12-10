//
//  RewindJourneyCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSData
import MSDomain
import RewindJourney

final class RewindJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start(with urls: [URL]) {
        let repository = SpotRepositoryImplementation()
        let viewModel = RewindJourneyViewModel(photoURLs: urls, repository: repository)
        let rewindJourneyViewController = RewindJourneyViewController(viewModel: viewModel)
        rewindJourneyViewController.navigationDelegate = self
        self.navigationController.pushViewController(rewindJourneyViewController, animated: true)
    }
    
}

// MARK: - HomeMap Coordinator

extension RewindJourneyCoordinator: HomeCoordinatorDelegate {
    func popToHomeWithSpot(from coordinator: Coordinator, spot: Spot) {
        // 미사용 함수
    }
    
    func popToHome(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHome(from: self)
    }
    
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey) {
        
    }
    
}

// MARK: - RewindJourney Navigation

extension RewindJourneyCoordinator: RewindJourneyNavigationDelegate {
    
    func popToHomeMap() {
        self.popToHome(from: self)
    }
    
}
