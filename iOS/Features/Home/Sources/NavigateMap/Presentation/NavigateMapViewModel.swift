//
//  NavigateMapViewModel.swift
//  Home
//
//  Created by 윤동주 on 11/26/23.
//

import Combine
import CoreLocation
import Foundation

import MSData
import MSDomain
import MSLogger

public final class NavigateMapViewModel {
    
    public enum Action {
        case locationDidUpdated(CLLocationCoordinate2D)
    }
    
    public struct State {
        var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        
        var visibleJourneys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    private let repository: JourneyRepository
    
    public var state = State()
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .locationDidUpdated(let newCurrentCoordinate):
            self.state.previousCoordinate.send(self.state.currentCoordinate.value)
            self.state.currentCoordinate.send(newCurrentCoordinate)
        }
    }
    
}
