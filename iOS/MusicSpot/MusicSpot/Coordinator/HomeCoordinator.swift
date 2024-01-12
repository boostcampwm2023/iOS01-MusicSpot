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
import RewindJourney

final class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    
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
        
        // Home (Bottom Sheet)
        let userRepository = UserRepositoryImplementation()
        let homeViewModel = HomeViewModel(journeyRepository: journeyRepository, userRepository: userRepository)
        let homeViewController = HomeViewController(viewModel: homeViewModel,
                                                    contentViewController: navigateMapViewController,
                                                    bottomSheetViewController: journeyListViewController)
        homeViewController.navigationDelegate = self
        self.rootViewController = homeViewController
        
        let configuration = HomeViewController.Configuration(fullDimension: .fractional(1.0),
                                                             detentDimension: .fractional(0.4),
                                                             minimizedDimension: .absolute(100.0))
        homeViewController.configuration = configuration
        
        navigateMapViewController.delegate = homeViewController
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
    
}

// MARK: - Finish Delegate

extension HomeCoordinator: CoordinatorFinishDelegate {
    
    func shouldFinish(childCoordinator: Coordinator) {
        guard let homeViewController = self.rootViewController else { return }
        
        self.childCoordinators.removeAll { $0 === childCoordinator }
        self.navigationController.popToViewController(homeViewController, animated: true)
    }
    
}

// MARK: - Finish Delegate: Spot

extension HomeCoordinator: SpotCoordinatorFinishDelegate {
    
    func shouldFinish(childCoordinator: Coordinator, with spot: Spot?, photoData: Data?) {
        guard let homeViewController = self.rootViewController as? HomeViewController else { return }
        
        if let spot = spot, let photoData = photoData {
            homeViewController.spotDidAdded(spot, photoData: photoData)
        }
        
        self.shouldFinish(childCoordinator: childCoordinator)
    }
    
}

// MARK: - Finish Delegate: SaveJourneyFlow

extension HomeCoordinator: SaveJourneyFlowCoordinatorFinishDelegate {
    
    func shouldFinish(childCoordinator: Coordinator, with endedJourney: Journey) {
        guard let homeViewController = self.rootViewController as? HomeViewController else { return }
        
        homeViewController.journeyDidEnded(endedJourney: endedJourney)
        
        self.shouldFinish(childCoordinator: childCoordinator)
    }
    
}

// MARK: - Finish Delegate: RewindJourney

extension HomeCoordinator: RewindJourneyCoordinatorFinishDelegate {
    
    func rewindJourneyShouldFinish(childCooridnator: Coordinator) {
        guard let presentedViewController = self.navigationController.presentedViewController else {
            return
        }
        
        self.childCoordinators.removeAll { $0 === childCooridnator }
        presentedViewController.dismiss(animated: true)
    }
    
}

// MARK: - Home Navigation

extension HomeCoordinator: HomeNavigationDelegate {
    
    func navigateToSpot(spotCoordinate coordinate: Coordinate) {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.finishDelegate = self
        spotCoordinator.spotFinishDelegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start(spotCoordinate: coordinate)
    }
    
    func navigateToSaveJourneyFlow(lastCoordinate: Coordinate) {
        let saveJourneyFlowCoordinator = SaveJourneyFlowCoordinator(navigationController: self.navigationController)
        saveJourneyFlowCoordinator.finishDelegate = self
        saveJourneyFlowCoordinator.saveJourneyFinishDelegate = self
        self.childCoordinators.append(saveJourneyFlowCoordinator)
        saveJourneyFlowCoordinator.start(lastCoordinate: lastCoordinate)
    }
    
}

// MARK: - JourneyList Navigation

extension HomeCoordinator: JourneyListNavigationDelegate {
    
    func navigateToRewindJourney(with urls: [URL], music: Music) {
        let rewindJourneyCoordinator = RewindJourneyCoordinator(navigationController: self.navigationController)
        rewindJourneyCoordinator.finishDelegate = self
        rewindJourneyCoordinator.rewindJourneyFinishDelegate = self
        self.childCoordinators.append(rewindJourneyCoordinator)
        rewindJourneyCoordinator.start(with: urls, music: music)
    }
    
}
