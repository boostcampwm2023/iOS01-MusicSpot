//
//  SplashViewModel.swift
//  Splash
//
//  Created by 이창준 on 2024.02.14.
//

import Combine
import Foundation

import MSLogger
import VersionManager

public final class SplashViewModel {
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        let isUpdateNeeded = PassthroughSubject<(Bool, String?), Never>()
    }
    
    // MARK: - Properties
    
    private var state = State()
    
    public var currentState: State {
        return self.state
    }
    
    private let version: VersionManager
    
    // MARK: - Initializer
    
    public init(versionManager: VersionManager = VersionManager()) {
        self.version = versionManager
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.checkIfUpdateNeeded()
        }
    }
}

private extension SplashViewModel {
    func checkIfUpdateNeeded() {
        Task {
            do {
                let isUpdateNeeded = try await self.version.isUpdateAvailable()
                self.state.isUpdateNeeded.send(isUpdateNeeded)
            } catch {
                MSLogger.make(category: .version).error("\(error)")
            }
        }
    }
}
