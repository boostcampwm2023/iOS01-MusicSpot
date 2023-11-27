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
            Task {
                let result = await self.repository.fetchJourneyList()
                
                switch result {
                case .success(let journeys):
                    let journeys = journeys.map { Journey(dto: $0) }
                    self.state.journeys.send(journeys)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
