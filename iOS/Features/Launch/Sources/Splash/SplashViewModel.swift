//
//  SplashViewModel.swift
//  Splash
//
//  Created by 이창준 on 2024.02.14.
//

import Combine
import Foundation

import MSLogger

public final class SplashViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        let goodToGo = PassthroughSubject<Void, Never>()
    }
    
    // MARK: - Properties
    
    private var state = State()
    
    public var currentState: State {
        return self.state
    }
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.state.goodToGo.send()
            //        Task {
            //            let isUpdateNeeded = await self.checkIfAppNeedsUpdate()
            //
            //            if isUpdateNeeded,
            //               let appStoreURL = self.versionManager.appStoreURL,
            //               UIApplication.shared.canOpenURL(appStoreURL) {
            //                await UIApplication.shared.open(appStoreURL)
            //            } else {
            //                let navigationController = self.navigationController
            //                let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            //                self.childCoordinators.append(homeCoordinator)
            //                homeCoordinator.start()
            //            }
            //        }
        }
    }
    
}
