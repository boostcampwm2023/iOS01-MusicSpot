//
//  NavigateMapViewModel.swift
//  Home
//
//  Created by 윤동주 on 11/26/23.
//

import Combine
import CoreLocation
import Foundation

import MSConstants
import MSData
import MSDomain
import MSLogger
import MSUserDefaults

public final class NavigateMapViewModel: MapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case visibleJourneysDidUpdated(_ visibleJourneys: [Journey])
    }
    
    public struct State {
        // Passthrough
        public var locationShouldAuthorized = PassthroughSubject<Bool, Never>()
        
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
        case .viewNeedsLoaded:
            self.state.locationShouldAuthorized.send(true)
        case .visibleJourneysDidUpdated(let visibleJourneys):
            self.state.visibleJourneys.send(visibleJourneys)
        }
    }
    
}
