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
    func popToHomeWithSpot(from coordinator: Coordinator, spot: Spot)
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey)
    
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
        let navigateMapViewController = MapViewController(viewModel: navigateMapViewmodel)
        
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
        navigateMapViewController.delegate = homeViewController
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
    
}

// MARK: - Home Navigation

extension HomeCoordinator: HomeNavigationDelegate {
    
    func navigateToSpot(spotCoordinate coordinate: Coordinate) {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.delegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start(spotCoordinate: coordinate)
    }
    
    func navigateToSelectSong(lastCoordinate: Coordinate) {
        let selectSongCoordinator = SelectSongCoordinator(navigationController: self.navigationController)
        selectSongCoordinator.delegate = self
        self.childCoordinators.append(selectSongCoordinator)
        selectSongCoordinator.start(lastCoordinate: lastCoordinate)
    }
    
}

// MARK: - JourneyList Navigation

extension HomeCoordinator: JourneyListNavigationDelegate {
    
    func navigateToRewindJourney(with urls: [URL], music: Music) {
        let rewindJourneyCoordinator = RewindJourneyCoordinator(navigationController: self.navigationController)
        rewindJourneyCoordinator.delegate = self
        self.childCoordinators.append(rewindJourneyCoordinator)
        rewindJourneyCoordinator.start(with: urls, music: music)
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
    
    func popToHomeWithSpot(from coordinator: Coordinator, spot: Spot) {
        guard let homeViewController = self.navigationController.viewControllers.first(where: { viewController in
            viewController is HomeViewController
        }) as? HomeBottomSheetViewController else {
            return
        }
        homeViewController.contentViewController.addSpotInRecording(spot: spot)
        self.navigationController.dismiss(animated: true) { [weak self] in
            self?.navigationController.popToViewController(homeViewController, animated: true)
            self?.childCoordinators.removeAll()
        }
    }
      
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey) {
        let viewControllers = self.navigationController.viewControllers
        guard let viewController = viewControllers.first(where: { $0 is HomeViewController }),
              let homeViewController = viewController as? HomeViewController else {
            return
        }
        
        self.navigationController.popToViewController(homeViewController, animated: true)
    }
    
}
