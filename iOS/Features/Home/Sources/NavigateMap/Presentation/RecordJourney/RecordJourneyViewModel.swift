//
//  RecordJourneyViewModel.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Combine
import CoreLocation
import Foundation

import MSDomain

public final class RecordJourneyViewModel: MapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        // CurrentValue
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var recordingJourney: CurrentValueSubject<RecordingJourney, Never>
    }
    
    // MARK: - Properties
    
    public var state: State
    
    // MARK: - Initializer
    
    public init(startedJourney: RecordingJourney) {
        self.state = State(recordingJourney: CurrentValueSubject<RecordingJourney, Never>(startedJourney))
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            print("View Needs Loaded")
        }
    }
    
}
