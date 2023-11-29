//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

final class AppCoordinator: Coordinator,
                                HomeMapCoordinatorDelegate,
                                SpotCoordinatorDelegate,
                                RewindCoordinatorDelegate,
                                SettingCoordinatorDelegate,
                                SearchMusicCoordinatorDelegate,
                            SaveJourneyCoordinatorDelegate {

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

    func navigateToSpot(coordinator: HomeMapCoordinator) {
        let spotCoordinator = SpotCoordinator(navigationController: navigationController)
        spotCoordinator.delegate = self

        self.childCoordinators.append(spotCoordinator)
        spotCoordinator.start()
    }

    func navigateToRewind(coordinator: HomeMapCoordinator) {
        let rewindCoordinator = RewindCoordinator(navigationController: navigationController)
        rewindCoordinator.delegate = self

        self.childCoordinators.append(rewindCoordinator)
        rewindCoordinator.start()
    }

    func navigateToSetting(coordinator: HomeMapCoordinator) {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.delegate = self

        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }

    func navigateToHomeMap(coordinator: SpotCoordinator) {
        removeChildCoordinator(child: coordinator)
        navigationController.popViewController(animated: true)
    }

    func navigateToHomeMap(coordinator: RewindCoordinator) {
        removeChildCoordinator(child: coordinator)
        navigationController.popViewController(animated: true)
    }

    func navigateToHomeMap(coordinator: SettingCoordinator) {
        navigationController.popViewController(animated: true)
    }

    // MARK: - From: Spot

    func navigateToSearchMusic(coordinator: SpotCoordinator) {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        searchMusicCoordinator.delegate = self
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }

    // MARK: - From: SearchMusic

    func navigateToHomeMap(coordinator: SearchMusicCoordinator) {
        guard let homeMapViewController = navigationController.viewControllers.first(where: {
            $0 is HomeMapViewController
        }) else {
            navigationController.setViewControllers([HomeMapViewController()], animated: true)
            return
        }

        while navigationController.topViewController !== homeMapViewController {
            navigationController.popViewController(animated: true)
        }
    }

    func navigateToSaveJourney(coordinator: SearchMusicCoordinator) {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: navigationController)
        saveJourneyCoordinator.delegate = self
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start()
    }

    // MARK: - From: SaveJourney
    func navigateToHomeMap(coordinator: SaveJourneyCoordinator) {
        guard let homeMapViewController = navigationController.viewControllers.first(where: {
            $0 is HomeMapViewController
        }) else {
            navigationController.setViewControllers([HomeMapViewController()], animated: true)
            return
        }

        while navigationController.topViewController !== homeMapViewController {
            navigationController.popViewController(animated: true)
        }
    }

    func navigateToSearchMusic(coordinator: SaveJourneyCoordinator) {
        let searchMusicCoordinator = SearchMusicCoordinator(navigationController: navigationController)
        searchMusicCoordinator.delegate = self
        self.childCoordinators.append(searchMusicCoordinator)
        searchMusicCoordinator.start()
    }
}
