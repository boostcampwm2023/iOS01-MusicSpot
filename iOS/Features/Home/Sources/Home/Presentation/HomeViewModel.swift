//
//  HomeViewModel.swift
//  Home
//
//  Created by 이창준 on 2023.12.06.
//

import Combine
import Foundation

import MSConstants
import MSData
import MSDomain
import MSImageFetcher
#if DEBUG
import MSKeychainStorage
#endif
import MSLogger
import MSUserDefaults

public final class HomeViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case viewNeedsReloaded
        case startButtonDidTap(Coordinate)
        case refreshButtonDidTap(visibleCoordinates: (minCoordinate: Coordinate, maxCoordinate: Coordinate))
        case backButtonDidTap
        case mapViewDidChange
    }
    
    public struct State {
        // Passthrough
        public var startedJourney = PassthroughSubject<RecordingJourney, Never>()
        public var visibleJourneys = PassthroughSubject<[Journey], Never>()
        public var overlaysShouldBeCleared = PassthroughSubject<Bool, Never>()
        
        // CurrentValue
        public var isRecording = CurrentValueSubject<Bool, Never>(false)
        public var isRefreshButtonHidden = CurrentValueSubject<Bool, Never>(false)
        public var isStartButtonLoading = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private var journeyRepository: JourneyRepository
    private let userRepository: UserRepository
    
    #if DEBUG
    private let keychain = MSKeychainStorage()
    #endif
    
    @UserDefaultsWrapped(UserDefaultsKey.isFirstLaunch, defaultValue: false)
    private var isFirstLaunch: Bool
    
    // MARK: - Initializer
    
    public init(journeyRepository: JourneyRepository,
                userRepository: UserRepository) {
        self.journeyRepository = journeyRepository
        self.userRepository = userRepository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            #if DEBUG
            let firstLaunchMessage = self.isFirstLaunch ? "앱이 처음 실행되었습니다." : "앱 첫 실행이 아닙니다."
            MSLogger.make(category: .userDefaults).debug("\(firstLaunchMessage)")
            #endif
            
            self.createNewUserWhenFirstLaunch()
        case .viewNeedsReloaded:
            let isRecording = self.journeyRepository.fetchIsRecording()
            self.state.isRecording.send(isRecording)
        case .startButtonDidTap(let coordinate):
            #if DEBUG
            MSLogger.make(category: .home).debug("Start 버튼 탭: \(coordinate)")
            #endif
            self.startJourney(at: coordinate)
        case .refreshButtonDidTap(visibleCoordinates: (let minCoordinate, let maxCoordinate)):
            self.state.isRefreshButtonHidden.send(true)
            self.fetchJourneys(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
        case .backButtonDidTap:
            self.state.isRecording.send(false)
            self.state.overlaysShouldBeCleared.send(true)
        case .mapViewDidChange:
            self.state.isRefreshButtonHidden.send(false)
        }
    }
    
}

// MARK: - Privates

private extension HomeViewModel {
    
    func createNewUserWhenFirstLaunch() {
        guard self.isFirstLaunch else { return }
        
        Task {
            let result = await self.userRepository.createUser()
            switch result {
            case .success(let userID):
                #if DEBUG
                MSLogger.make(category: .home).log("\(userID) 유저가 생성되었습니다.")
                #endif
                self.isFirstLaunch = false
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
    func startJourney(at coordinate: Coordinate) {
        Task {
            self.state.isStartButtonLoading.send(true)
            defer { self.state.isStartButtonLoading.send(false) }
            
            guard let userID = self.userRepository.fetchUUID() else { return }
            
            let result = await self.journeyRepository.startJourney(at: coordinate, userID: userID)
            switch result {
            case .success(let recordingJourney):
                self.state.startedJourney.send(recordingJourney)
                self.state.isRecording.send(true)
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
    func fetchJourneys(minCoordinate: Coordinate, maxCoordinate: Coordinate) {
        guard let userID = self.userRepository.fetchUUID() else { return }
        
        Task {
            let result = await self.journeyRepository.fetchJourneyList(userID: userID,
                                                                       minCoordinate: minCoordinate,
                                                                       maxCoordinate: maxCoordinate)
            switch result {
            case .success(let journeys):
                self.state.visibleJourneys.send(journeys)
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
}
