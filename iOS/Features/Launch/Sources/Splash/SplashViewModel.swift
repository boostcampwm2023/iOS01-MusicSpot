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
        
    }
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            print("View did load.")
        }
    }
    
}
