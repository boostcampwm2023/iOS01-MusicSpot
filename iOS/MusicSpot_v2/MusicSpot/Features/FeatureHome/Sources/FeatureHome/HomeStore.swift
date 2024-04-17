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
    
    enum Action {
        case increaseCounter
    }
    
    private(set) var counter: Int = .zero
    
    func process(_ action: Action) async {
        switch action {
        case .increaseCounter:
            self.counter += 1
        }
    }
    
}
