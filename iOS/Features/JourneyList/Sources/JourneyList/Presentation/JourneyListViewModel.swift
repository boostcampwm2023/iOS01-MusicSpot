//
//  JourneyListViewModel.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import Combine
import Foundation

import MSData
import MSDomain

public final class JourneyListViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case visibleJourneysDidUpdated([Journey])
    }
    
    public struct State {
        // CurrentValue
        public var journeys = CurrentValueSubject<[Journey], Never>([])
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private let repository: JourneyRepository
    
    // MARK: - Initializer
    
    public init(repository: JourneyRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            print("ViewNeedsLoaded")
        case .visibleJourneysDidUpdated(let visibleJourneys):
            self.state.journeys.send(visibleJourneys)
        }
    }
    
}
