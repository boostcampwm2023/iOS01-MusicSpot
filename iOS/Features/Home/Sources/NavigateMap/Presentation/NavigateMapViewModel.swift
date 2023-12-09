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

public final class NavigateMapViewModel {
    
    public enum Action {
        case locationDidUpdated(CLLocationCoordinate2D)
        case recordCoordinate(RecordingJourney)
    }
    
    public struct State {
        var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        
        var journeyID = CurrentValueSubject<String?, Never>(nil)
        var recordingCoordinates = CurrentValueSubject<[Coordinate]?, Never>(nil)
        
        public init() { }
    }
    
    // MARK: - Properties

    private let journeyRepository: JourneyRepository
    
    public var state = State()
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.journeyRepository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
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
