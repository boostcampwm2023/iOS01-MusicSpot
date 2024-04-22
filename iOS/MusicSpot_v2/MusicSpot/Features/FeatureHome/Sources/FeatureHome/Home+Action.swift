//
//  Home+Action.swift
//  Home
//
//  Created by 이창준 on 4/20/24.
//

import Foundation

extension Home {
    
    enum Action {
        case startButtonDidTap
        case mapButtonDidTap
        case locationButtonDidTap
    }
    
    func perform(_ action: Action) {
        switch action {
        case .startButtonDidTap:
            self.handleStartButtonTap()
        case .mapButtonDidTap:
            print("Map")
        case .locationButtonDidTap:
            print("Location")
        }
    }
    
    private func handleStartButtonTap() {
        
    }
    
}
