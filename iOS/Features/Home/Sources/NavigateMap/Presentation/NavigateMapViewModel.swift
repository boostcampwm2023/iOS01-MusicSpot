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
import MSUserDefaults

public final class NavigateMapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case locationDidUpdated(CLLocationCoordinate2D)
        case recordCoordinate(RecordingJourney)
    }
    
    public struct State {
        
        public var visibleJourneys = CurrentValueSubject<[Journey], Never>([])
        
        public var locationShouldAuthorized = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Properties

    private let journeyRepository: JourneyRepository
    
    public var state = State()
    
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    private var isRecording: Bool
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.journeyRepository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.state.locationShouldAuthorized.send(true)
        case .locationDidUpdated(let newCurrentCoordinate):
            self.state.previousCoordinate.send(self.state.currentCoordinate.value)
            self.state.currentCoordinate.send(newCurrentCoordinate)
        case .recordCoordinate(let recordJourney):
            Task {
                let result = await self.journeyRepository.recordJourney(journeyID: recordJourney.id,
                                                                        at: recordJourney.coordinates)
                switch result {
                case .success(let journey):
                    self.state.journeyID.send(journey.id)
                    self.state.recordingCoordinates.send(journey.coordinates)
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        }
        
    }
    
}
