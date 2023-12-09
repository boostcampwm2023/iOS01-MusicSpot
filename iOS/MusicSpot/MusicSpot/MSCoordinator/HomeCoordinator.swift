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
import MSDomain
import MSUIKit
import NavigateMap

protocol HomeCoordinatorDelegate: AnyObject {
    
    func popToHome(from coordinator: Coordinator)
    
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
        
        let journeyRepository = JourneyRepositoryImplementation()
        
        // NavigateMap
        let navigateMapViewmodel = NavigateMapViewModel(repository: journeyRepository)
        let navigateMapViewController = NavigateMapViewController(viewModel: navigateMapViewmodel)
        
        // Journey List
        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
        journeyListViewController.navigationDelegate = self
        
        // Bottom Sheet
        let userRepository = UserRepositoryImplementation()
        let homeViewModel = HomeViewModel(journeyRepository: journeyRepository, userRepository: userRepository)
        let homeViewController = HomeViewController(viewModel: homeViewModel,
                                                    contentViewController: navigateMapViewController,
                                                    bottomSheetViewController: journeyListViewController)
        let configuration = HomeViewController.Configuration(fullDimension: .fractional(1.0),
                                                             detentDimension: .fractional(0.4),
                                                             minimizedDimension: .absolute(100.0))
        homeViewController.configuration = configuration
        homeViewController.navigationDelegate = self
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
    
}

// MARK: - Home Navigation

extension HomeCoordinator: HomeNavigationDelegate {
    
    func navigateToSpot(recordingJourney: RecordingJourney,
                        coordinate: Coordinate) {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.delegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start(recordingJourney: recordingJourney, coordinate: coordinate)
    }
    
    func navigateToSelectSong(recordingJourney: RecordingJourney, lastCoordinate: Coordinate) {
        let selectSongCoordinator = SelectSongCoordinator(navigationController: self.navigationController)
        selectSongCoordinator.delegate = self
        self.childCoordinators.append(selectSongCoordinator)
        selectSongCoordinator.start(recordingJourney: recordingJourney, lastCoordinate: lastCoordinate)
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
    
    func popToHome(from coordinator: Coordinator) {
        guard let homeViewController = self.navigationController.viewControllers.first(where: { viewController in
            viewController is HomeViewController
        }) else {
            return
        }
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.navigationController.popToViewController(homeViewController, animated: true)
            self?.childCoordinators.removeAll()
        }
    }
    
}
