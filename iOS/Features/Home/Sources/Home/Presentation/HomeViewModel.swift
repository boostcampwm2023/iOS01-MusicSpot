//
//  HomeViewModel.swift
//  Home
//
//  Created by 이창준 on 2023.12.06.
//

import ActivityKit
import Combine
import Foundation

import MSConstants
import MSData
import MSDomain
import MSImageFetcher
import MSLogger
import MSUserDefaults

public final class HomeViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case viewNeedsReloaded
        case startButtonDidTap(Coordinate)
        case refreshButtonDidTap(visibleCoordinates: (minCoordinate: Coordinate, maxCoordinate: Coordinate))
        case backButtonDidTap
        case recordingStateDidChange(Bool)
        case mapViewDidChange
    }
    
    public struct State {
        // Passthrough
        public var journeyDidStarted = PassthroughSubject<RecordingJourney, Never>()
        public var journeyDidResumed = PassthroughSubject<RecordingJourney, Never>()
        public var journeyDidCancelled = PassthroughSubject<RecordingJourney, Error>()
        public var visibleJourneys = PassthroughSubject<[Journey], Never>()
        
        // CurrentValue
        public var isRecording = CurrentValueSubject<Bool, Never>(false)
        public var isRefreshButtonHidden = CurrentValueSubject<Bool, Never>(false)
        public var isStartButtonLoading = CurrentValueSubject<Bool, Never>(false)
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private var journeyRepository: JourneyRepository
    private let userRepository: UserRepository
    
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
            
            self.resumeJourneyIfNeeded()
        case .viewNeedsReloaded:
            self.syncRecordingState()
        case .startButtonDidTap(let coordinate):
            #if DEBUG
            MSLogger.make(category: .home).debug("시작 버튼이 탭 되었습니다: \(coordinate)")
            #endif
            self.startJourney(at: coordinate)
        case .refreshButtonDidTap(visibleCoordinates: (let minCoordinate, let maxCoordinate)):
            self.state.isRefreshButtonHidden.send(true)
            self.fetchJourneys(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
        case .backButtonDidTap:
            #if DEBUG
            MSLogger.make(category: .home).debug("취소 버튼이 탭 되었습니다.")
            #endif
            self.cancelJourney()
        case .recordingStateDidChange(let isRecording):
            self.state.isRecording.send(isRecording)
        case .mapViewDidChange:
            if self.state.isRecording.value == false {
                self.state.isRefreshButtonHidden.send(false)
            }
        }
    }
    
}

// MARK: - Privates

private extension HomeViewModel {
    
    private var shouldSignIn: Bool {
        return self.isFirstLaunch || self.userRepository.fetchUUID() == nil
    }
    
    func createNewUserWhenFirstLaunch() {
        guard self.shouldSignIn else { return }
        
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
    
    func startJourney(at coordinate: Coordinate) {
        Task {
            defer { self.syncRecordingState() }
            
            self.state.isStartButtonLoading.send(true)
            defer { self.state.isStartButtonLoading.send(false) }
            
            guard let userID = self.userRepository.fetchUUID() else { return }
            
            let result = await self.journeyRepository.startJourney(at: coordinate, userID: userID)
            switch result {
            case .success(let recordingJourney):
                self.state.journeyDidStarted.send(recordingJourney)
                self.state.isRefreshButtonHidden.send(true)
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
    func resumeJourneyIfNeeded() {
        defer { self.syncRecordingState() }
        
        guard let recordingJourney = self.journeyRepository.fetchRecordingJourney() else {
            return
        }
        
        self.state.journeyDidResumed.send(recordingJourney)
    }
    
    func cancelJourney() {
        guard let userID = self.userRepository.fetchUUID(),
              let recordingJourney = self.journeyRepository.fetchRecordingJourney() else {
            return
        }
        
        Task {
            defer { self.syncRecordingState() }
            
            let result = await self.journeyRepository.deleteJourney(recordingJourney, userID: userID)
            switch result {
            case .success(let deletedJourney):
                self.state.journeyDidCancelled.send(deletedJourney)
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
                self.state.journeyDidCancelled.send(completion: .failure(error))
            }
        }
    }
    
    func syncRecordingState() {
        let isRecording = self.journeyRepository.isRecording
        #if DEBUG
        MSLogger.make(category: .home)
            .debug("여정 기록 여부를 싱크하고 있습니다. 현재 기록 상태: \(isRecording ? "기록 중" : "기록 중이지 않음")")
        #endif
        self.state.isRecording.send(isRecording)
    }
    
}
