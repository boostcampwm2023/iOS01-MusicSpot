//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine

import MSData

public final class SaveJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case mediaControlButtonDidTap
        case nextButtonDidTap
    }
    
    public struct State {
        var music = CurrentValueSubject<String, Never>("")
        var journeys = CurrentValueSubject<[Journey], Never>([])
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
        case .viewNeedsLoaded:
            Task {
                let result = await self.repository.fetchJourneyList()
                switch result {
                case .success(let journeyDTOs):
                    let journeys = journeyDTOs.map { Journey(dto: $0) }
                    self.state.journeys.send(journeys)
                case .failure(let error):
                    print(error)
                }
            }
        case .mediaControlButtonDidTap:
            print("Media Control Button Tap.")
        case .nextButtonDidTap:
            print("Next Button Tap.")
        }
    }
    
}
