//
//  JourneyListViewModel.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Combine

public final class JourneyListViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        var journeys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(state: State = State()) {
        self.state = state
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.fetchInitialJourneys()
        }
    }
    
}

private extension JourneyListViewModel {
    
    func fetchInitialJourneys() {
        self.state.journeys.send([Journey(locatoin: "여정 위치",
                                          date: "2023. 01. 01",
                                          spot: Spot(images: ["sdlkj", "sdklfj"])),
                                  Journey(locatoin: "여정 위치",
                                          date: "2023. 01. 02",
                                          spot: Spot(images: ["slkjc", "llskl", "llskldf", "llskl5", "llskl12"]))])
    }
    
}
