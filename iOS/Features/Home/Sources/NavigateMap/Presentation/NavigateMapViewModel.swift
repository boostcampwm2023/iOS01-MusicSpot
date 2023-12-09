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
    }
    
    public struct State {
        public var isRecording = CurrentValueSubject<Bool, Never>(false)
        public var previousCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        public var currentCoordinate = CurrentValueSubject<CLLocationCoordinate2D?, Never>(nil)
        
        public var visibleJourneys = CurrentValueSubject<[Journey], Never>([])
        
        public var locationShouldAuthorized = PassthroughSubject<Bool, Never>()
    }
    
    // MARK: - Properties
    
    private let repository: JourneyRepository
    
    public var state = State()
    
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    private var isRecording: Bool
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.state.locationShouldAuthorized.send(true)
        case .locationDidUpdated(let newCurrentCoordinate):
            self.state.previousCoordinate.send(self.state.currentCoordinate.value)
            self.state.currentCoordinate.send(newCurrentCoordinate)
        }
    }
    
}
