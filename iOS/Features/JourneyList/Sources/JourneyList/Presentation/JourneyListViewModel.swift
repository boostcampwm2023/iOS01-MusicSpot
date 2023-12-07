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
        case fetchJourney(at: (minCoordinate: Coordinate, maxCoordinate: Coordinate))
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
            print("ViewNeedsLoaded")
        case .fetchJourney(at: (let minCoordinate, let maxCoordinate)):
            Task {
                let result = await self.repository.fetchJourneyList(minCoordinate: minCoordinate,
                                                                    maxCoordinate: maxCoordinate)
                switch result {
                case .success(let journeys):
                    print(journeys)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
