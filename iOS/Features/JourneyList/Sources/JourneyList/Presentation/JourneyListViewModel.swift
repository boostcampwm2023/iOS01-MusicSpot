//
//  JourneyListViewModel.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Combine
import Foundation

import MSData

public final class JourneyListViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        var journeys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private let repository: JourneyRepository
    
    // MARK: - Initializer
    
    public init(repository: JourneyRepository) {
        self.repository = repository
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
        self.state.journeys.send([Journey(location: "여정 위치",
                                          date: .now,
                                          spots: [
                                            Spot(photoURLs: ["sdlkj", "sdklfj"])
                                          ],
                                          song: Song(artist: "sdlkfj", title: "sdklfj")),
                                  Journey(location: "여정 위치",
                                          date: .now,
                                          spots: [
                                            Spot(photoURLs: ["sdlkj", "sdklfj"])
                                          ],
                                          song: Song(artist: "sdlkfj", title: "sdklfj"))])
    }
    
}
