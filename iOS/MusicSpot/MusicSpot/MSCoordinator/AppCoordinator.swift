//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class AppCoordinator: Coordinator {

    // MARK: - Properties

    let navigationController: UINavigationController

    var childCoordinators: [Coordinator] = []

    // MARK: - Initializer

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - From: HomeMap

    func start() {
        let homeMapCoordinator = HomeMapCoordinator(navigationController: navigationController)
        homeMapCoordinator.delegate = self
        self.childCoordinators.append(homeMapCoordinator)
        homeMapCoordinator.start()
    }
}

extension AppCoordinator {
    
    /// 현재 ViewController 아래에 깔린 ViewController 내에서 HomeMapViewController를 찾는 함수
    private func findHomeMapViewController() {
        guard let homeMapViewController = navigationController.viewControllers.first(where: { $0 is HomeMapViewController }) else {
            navigationController.setViewControllers([HomeMapViewController()], animated: true)
            return
        }

        navigationController.popToViewController(homeMapViewController, animated: true)
    }
}

// MARK: - HomeMapCoordinatorDelegate

extension AppCoordinator: HomeMapCoordinatorDelegate {
    
    /// From: HomeMap, To: Spot
    func pushToSpot(coordinator: HomeMapCoordinator) {
        let spotCoordinator = SpotCoordinator(navigationController: navigationController)
        spotCoordinator.delegate = self

        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }

    /// From: HomeMap, To: Rewind
    func pushToRewind(coordinator: HomeMapCoordinator) {
        let rewindCoordinator = RewindCoordinator(navigationController: navigationController)
        rewindCoordinator.delegate = self

        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }

    /// From: HomeMap, To: Setting
    func pushToSetting(coordinator: HomeMapCoordinator) {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.delegate = self

        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
}

// MARK: - SpotCoordinatorDelegate

extension AppCoordinator: SpotCoordinatorDelegate {
    
    /// From: Spot, To: HomeMap
    func popToHomeMap(coordinator: SpotCoordinator) {
        removeChildCoordinator(child: coordinator)
        navigationController.popViewController(animated: true)
    }
    
    /// From: Spot, To: SearchMusic
    func pushToSearchMusic(coordinator: SpotCoordinator) {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        searchMusicCoordinator.delegate = self
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
}

// MARK: - SearchMusicCoordinatorDelegate

extension AppCoordinator: SearchMusicCoordinatorDelegate {
    
    /// From: SearchMusic, To: HomeMap
    func popToHomeMap(coordinator: SearchMusicCoordinator) {
        findHomeMapViewController()
    }

    /// From: SearchMusic, To: SaveJourney
    func pushToSaveJourney(coordinator: SearchMusicCoordinator) {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: navigationController)
        saveJourneyCoordinator.delegate = self
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start()
    }
}

// MARK: - RewindCoordinatorDelegate

extension AppCoordinator: RewindCoordinatorDelegate {
    
    /// From: Rewind, To: HomeMap
    func popToHomeMap(coordinator: RewindCoordinator) {
        removeChildCoordinator(child: coordinator)
        navigationController.popViewController(animated: true)
    }
}

// MARK: - SettingCoordinatorDelegate

extension AppCoordinator: SettingCoordinatorDelegate {
    
    /// From: Setting, To: HomeMap
    func popToHomeMap(coordinator: SettingCoordinator) {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - SaveJourneyCoordinatorDelegate

extension AppCoordinator: SaveJourneyCoordinatorDelegate {
    
    /// From: SaveJourney, To: HomeMap
    func popToHomeMap(coordinator: SaveJourneyCoordinator) {
        findHomeMapViewController()
    }

    /// From: SaveJourney, To: SearchMusic
    func popToSearchMusic(coordinator: SaveJourneyCoordinator) {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        searchMusicCoordinator.delegate = self
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
}
