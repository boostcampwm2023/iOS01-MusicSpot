//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine

public final class SaveJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        var music = CurrentValueSubject<String, Never>("")
        var journeys = CurrentValueSubject<[Journey], Never>([])
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.fetchInitialJourneys()
        }
    }
    
}

private extension SaveJourneyViewModel {
    
    func fetchInitialJourneys() {
        self.state.music.send("NewJeans")
        self.state.journeys.send([Journey(locatoin: "여정 위치",
                                          date: "2023. 01. 01",
                                          spot: Spot(images: ["sdlkj", "sdklfj"])),
                                  Journey(locatoin: "여정 위치",
                                          date: "2023. 01. 02",
                                          spot: Spot(images: ["slkjc", "llskl", "llskldf", "llskl5", "llskl12"]))])
    }
    
}
