//
//  AppCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSLogger
import Version
import VersionManager

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    private let versionManager = VersionManager()
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    @MainActor
    func start() {
        Task {
            let isUpdateNeeded = await self.checkIfAppNeedsUpdate()
            
            if isUpdateNeeded,
               let appStoreURL = self.versionManager.appStoreURL,
               UIApplication.shared.canOpenURL(appStoreURL) {
                await UIApplication.shared.open(appStoreURL)
            } else {
                let navigationController = self.navigationController
                let homeCoordinator = HomeCoordinator(navigationController: navigationController)
                self.childCoordinators.append(homeCoordinator)
                homeCoordinator.start()
            }
        }
    }
    
}

// MARK: - Version Check

private extension AppCoordinator {
    
    func checkIfAppNeedsUpdate() async -> Bool {
        switch await self.versionManager.checkIfUpdateNeeded() {
        case .success(let isUpdateNeeded):
            return isUpdateNeeded
        case .failure(let error):
            MSLogger.make(category: .version).error("\(error.localizedDescription)")
            return false
        }
    }
    
}
