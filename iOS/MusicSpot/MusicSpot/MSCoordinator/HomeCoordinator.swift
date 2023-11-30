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
        let navigateMapViewController = NavigateMapViewController()
        
        // Journey List
        let journeyRepository = JourneyRepositoryImplementation()
        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
        journeyListViewController.delegate = self
        
        // Bottom Sheet
        let configuration = HomeBottomSheetViewController.BottomSheetConfiguration(fullHeight: 852.0,
                                                                                   detentHeight: 425.0,
                                                                                   minimizedHeight: 100.0)
        let homeBottomSheetVC = HomeBottomSheetViewController(contentViewController: navigateMapViewController,
                                                              bottomSheetViewController: journeyListViewController,
                                                              configuration: configuration)
        homeBottomSheetVC.delegate = self
        self.navigationController.pushViewController(homeBottomSheetVC, animated: true)
    }
    
}

// MARK: - NavigateMapViewController

extension HomeCoordinator: HomeViewControllerDelegate {
    
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
