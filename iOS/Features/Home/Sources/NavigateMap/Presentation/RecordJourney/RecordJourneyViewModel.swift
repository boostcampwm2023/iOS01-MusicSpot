//
//  RecordJourneyViewModel.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Combine
import CoreLocation
import Foundation

import MSData
import MSDomain
import MSLogger

public final class RecordJourneyViewModel: MapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case locationDidUpdated(CLLocationCoordinate2D)
        case locationsShouldRecorded([CLLocationCoordinate2D])
    }
    
    public struct State {
        // CurrentValue
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
    }
    
    // MARK: - Properties
    
    private let journeyRepository: JourneyRepository
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(startedJourney: RecordingJourney,
                journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
        self.state = State(recordingJourney: CurrentValueSubject<RecordingJourney, Never>(startedJourney))
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            #if DEBUG
            MSLogger.make(category: .home).debug("View Did load.")
            #endif
        case .locationDidUpdated(let coordinate):
            let previousCoordinate = self.state.currentCoordinate.value
            self.state.previousCoordinate.send(previousCoordinate)
            self.state.currentCoordinate.send(coordinate)
        case .locationsShouldRecorded(let coordinates):
            Task {
                let recordingJourney = self.state.recordingJourney.value
                let coordinates = coordinates.map { Coordinate(latitude: $0.latitude, longitude: $0.longitude) }
                let result = await self.journeyRepository.recordJourney(journeyID: recordingJourney.id,
                                                                        at: coordinates)
                switch result {
                case .success(let recordingJourney):
                    self.state.recordingJourney.send(recordingJourney)
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        }
    }
    
}
