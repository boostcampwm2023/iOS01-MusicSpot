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
        case recordingDidCancelled
    }
    
    public struct State {
        // CurrentValue
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
    }
    
    // MARK: - Properties
    
    private let userRepository: UserRepository
    private var journeyRepository: JourneyRepository
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(startedJourney: RecordingJourney,
                userRepository: UserRepository,
                journeyRepository: JourneyRepository) {
        self.userRepository = userRepository
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
        case .recordingDidCancelled:
            Task {
                guard let userID = self.userRepository.fetchUUID() else { return }
                
                let recordingJourney = self.state.recordingJourney.value
                let result = await self.journeyRepository.deleteJourney(recordingJourney, userID: userID)
                switch result {
                case .success(let cancelledJourney):
                    #if DEBUG
                    MSLogger.make(category: .home).debug("여정이 취소 되었습니다: \(cancelledJourney)")
                    #endif
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        }
    }
    
}
