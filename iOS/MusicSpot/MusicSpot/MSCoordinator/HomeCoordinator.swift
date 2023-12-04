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

protocol HomeMapCoordinatorDelegate: AnyObject {
    
    func popToHomeMap(from coordinator: Coordinator)
    
}

final class HomeCoordinator: Coordinator {
    
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
        // Navigate Map
        let navigateMapRepository = NavigateMapRepositoryImplementation()
        let navigateMapViewModel = NavigateMapViewModel(repository: navigateMapRepository)
        let navigateMapViewController = NavigateMapViewController(viewModel: navigateMapViewModel)
        
        // Journey List
        let journeyRepository = JourneyRepositoryImplementation()
        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
        journeyListViewController.delegate = self
        
        // Bottom Sheet
        let homeBottomSheetVC = HomeBottomSheetViewController(contentViewController: navigateMapViewController,
                                                              bottomSheetViewController: journeyListViewController)
        homeBottomSheetVC.configuration = MSBottomSheetViewController.Configuration(fullDimension: .fractional(1.0),
                                                                                    detentDimension: .fractional(0.4),
                                                                                    minimizedDimension: .absolute(100.0))
        homeBottomSheetVC.delegate = self
        self.navigationController.pushViewController(homeBottomSheetVC, animated: true)
    }
    
}

// MARK: - NavigateMapViewController

extension HomeCoordinator: HomeViewControllerDelegate {
    func navigateToSetting() {
        print(#function)
    }
    
    func navigateToSpot() {
        let spotCoordinator = SpotCoordinator(navigationController: self.navigationController)
        spotCoordinator.delegate = self
        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }
    
//    func navigateToSearchMusic() {
//        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: self.navigationController)
//        searchMusicCoordinator.delegate = self
//        self.childCoordinators.append(searchMusicCoordinator)
//        searchMusicCoordinator.start()
//    }
    
//    func navigateToSetting() {
//        let settingCoordinator = SettingCoordinator(navigationController: self.navigationController)
//        settingCoordinator.delegate = self
//        self.childCoordinators.append(settingCoordinator)
//        settingCoordinator.start()
//    }
    
}

extension HomeCoordinator: JourneyListViewControllerDelegate {
    
    func navigateToRewind() {
        let rewindCoordinator = RewindCoordinator(navigationController: self.navigationController)
        rewindCoordinator.delegate = self
        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }
    
}

// MARK: - HomeMap Coordinator

extension HomeCoordinator: HomeMapCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
