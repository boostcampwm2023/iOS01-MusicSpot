//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSLogger
import Splash
import Version

final class AppCoordinator: Coordinator {
    
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
        let storyboard = UIStoryboard(name: SplashViewController.storyboardName,
                                      bundle: Bundle.splash)
        let splashViewController = storyboard.instantiateViewController(identifier: SplashViewController.storyboardID,
                                                                        creator: {
            [weak self] coder -> SplashViewController in
            let viewModel = SplashViewModel()
            let viewController = SplashViewController(viewModel: viewModel, coder: coder)
            viewController?.navigationDelegate = self
            return viewController ?? SplashViewController(viewModel: viewModel)
        })
        
        self.navigationController.pushViewController(splashViewController, animated: false)
    }
    
}

// MARK: - Splash Navigation

extension AppCoordinator: SplashNavigationDelegate {
    
    func navigateToHome() {
        let navigationController = self.navigationController
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.start()
    }
    
    func navigateToUpdate() {
        let versionViewController = VersionViewController()
        self.navigationController.pushViewController(versionViewController, animated: true)
    }
    
}
