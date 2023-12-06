//
//  NavigateMapViewModel.swift
//  Home
//
//  Created by 윤동주 on 11/26/23.
//

import Foundation
import Combine

import MSData
import MSLogger

public final class NavigateMapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case fetchJourneys(at: Coordinate)
    }
    
    public struct State {
        var journeys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    private let repository: NavigateMapRepository
    
    public var state = State()
    
    // MARK: - Initializer

    public init(repository: NavigateMapRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let result = await self.repository.fetchJourneyList()
                
                switch result {
                case .success(let journeys):
                    let journeys = journeys.map { Journey(dto: $0) }
                    self.state.journeys.send(journeys)
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        case .fetchJourneys(let coordinate):
            print(coordinate)
        }
        
    }
    
}
