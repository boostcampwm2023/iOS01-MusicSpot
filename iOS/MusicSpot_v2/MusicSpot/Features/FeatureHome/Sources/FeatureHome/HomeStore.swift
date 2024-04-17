//
//  HomeViewModel.swift
//  Home
//
//  Created by 이창준 on 4/17/24.
//

import Foundation

import StateStore

@MainActor
@Observable
final class HomeStore: StateStore {
    
    // MARK: - Action
    
    enum Action {
        case increaseCounter
    }
    
    // MARK: - State
    
    private(set) var counter: Int = .zero
    
    // MARK: - Process
    
    func process(_ action: Action) async {
        switch action {
        case .increaseCounter:
            self.counter += 1
        }
    }
    
}
