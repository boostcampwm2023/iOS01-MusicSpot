//
//  NavigateMapViewModel.swift
//  Home
//
//  Created by 윤동주 on 11/26/23.
//

import Combine
import Foundation

import MSDomain
import MSLogger

public final class NavigateMapViewModel: MapViewModel {
    public enum Action {
        case visibleJourneysDidUpdated(_ visibleJourneys: [Journey])
    }
    
    public struct State {
        // CurrentValue
        public var visibleJourneys = CurrentValueSubject<[Journey], Never>([])
    }
    
    // MARK: - Properties

    private let journeyRepository: JourneyRepository
    
    public var state = State()
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.journeyRepository = repository
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .visibleJourneysDidUpdated(let visibleJourneys):
            self.state.visibleJourneys.send(visibleJourneys)
        }
    }
}
