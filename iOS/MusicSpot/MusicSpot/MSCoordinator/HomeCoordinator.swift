//
//  HomeCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import Home
import JourneyList
import MSData
import MSUIKit
import NavigateMap

protocol HomeCoordinatorDelegate: AnyObject {
    
    func popToHomeMap(from coordinator: Coordinator)
    
}

final class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: AppCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        // Navigate Map
        let navigateMapRepository = NavigateMapRepositoryImplementation()
        let navigateMapViewModel = NavigateMapViewModel(repository: navigateMapRepository)
        let navigateMapViewController = NavigateMapViewController(viewModel: navigateMapViewModel)
        
        // Journey List
        let journeyRepository = JourneyRepositoryImplementation()
        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
        journeyListViewController.navigationDelegate = self
        
        // Bottom Sheet
        let homeBottomSheetVC = HomeViewController(contentViewController: navigateMapViewController,
                                                              bottomSheetViewController: journeyListViewController)
        homeBottomSheetVC.configuration = MSBottomSheetViewController.Configuration(fullDimension: .fractional(1.0),
                                                                                    detentDimension: .fractional(0.4),
                                                                                    minimizedDimension: .absolute(100.0))
        homeBottomSheetVC.navigationDelegate = self
        self.navigationController.pushViewController(homeBottomSheetVC, animated: true)
    }
    
}

// MARK: - Home Navigation

extension HomeCoordinator: HomeNavigationDelegate {
    
    func navigateToSpot() {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.delegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }
    
    func navigateToSelectSong() {
        let selectSongCoordinator = SelectSongCoordinator(navigationController: self.navigationController)
        selectSongCoordinator.delegate = self
        self.childCoordinators.append(selectSongCoordinator)
        selectSongCoordinator.start()
    }
    
}

// MARK: - JourneyList Navigation

extension HomeCoordinator: JourneyListNavigationDelegate {
    
    func navigateToRewindJourney() {
        let rewindJourneyCoordinator = RewindJourneyCoordinator(navigationController: self.navigationController)
        rewindJourneyCoordinator.delegate = self
        self.childCoordinators.append(rewindJourneyCoordinator)
        rewindJourneyCoordinator.start()
    }
    
}

// MARK: - HomeMap Coordinator

extension HomeCoordinator: HomeCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
