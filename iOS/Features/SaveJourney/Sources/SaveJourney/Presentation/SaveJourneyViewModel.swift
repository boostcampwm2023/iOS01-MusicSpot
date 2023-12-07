//
//  SaveJourneyViewModel.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine

import MSData
import MSDomain
import MSLogger

public final class SaveJourneyViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case mediaControlButtonDidTap
    }
    
    public struct State {
        var song: CurrentValueSubject<Music, Never>
        var spots = CurrentValueSubject<[Spot], Never>([])
    }
    
    // MARK: - Properties
    
    private let journeyRepository: JourneyRepository
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(selectedMusic: Music,
                spotRepository: SpotRepository) {
        self.spotRepository = spotRepository
        self.state = State(song: CurrentValueSubject<Music, Never>(selectedMusic))
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            Task {
                let result = await self.journeyRepository.fetchRecordingJourney()
                switch result {
                case .success(let spots):
                    self.state.spots.send(spots)
                case .failure(let error):
                    #if DEBUG
                    MSLogger.make(category: .saveJourney).error("\(error)")
                    #endif
                }
            }
        case .mediaControlButtonDidTap:
            print("Media Control Button Tap.")
        }
    }
    
}
