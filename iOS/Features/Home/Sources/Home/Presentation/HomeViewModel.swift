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
        case startButtonDidTap(Coordinate)
        case fetchJourney(visibleMapRect: (minCoordinate: Coordinate, maxCoordinate: Coordinate))
    }
    
    public struct State {
        var recordingJourney = CurrentValueSubject<RecordingJourney?, Never>(nil)
        var journeys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private let journeyRepository: JourneyRepository
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
//            #if DEBUG
//            self.isFirstLaunch = true
//            try? self.keychain.deleteAll()
//            #endif
            let firstLaunchMessage = self.isFirstLaunch ? "앱이 처음 실행되었습니다." : "앱 첫 실행이 아닙니다."
            MSLogger.make(category: .userDefaults).log("\(firstLaunchMessage)")
            
            if self.isFirstLaunch {
                self.createNewUser()
            }
        case .startButtonDidTap(let coordinate):
            Task {
                let userID = try self.userRepository.fetchUUID()
                let result = await self.journeyRepository.startJourney(at: coordinate, userID: userID)
                switch result {
                case .success(let recordingJourney):
                    self.state.recordingJourney.send(recordingJourney)
                case .failure(let error):
                    MSLogger.make(category: .home).error("\(error)")
                }
            }
        case .fetchJourney(visibleMapRect: (let minCoordinate, let maxCoordinate)):
            self.fetchJourneys(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
        }
    }
    
}

// MARK: - Privates

private extension HomeViewModel {
    
    func createNewUser() {
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
    
    func fetchJourneys(minCoordinate: Coordinate, maxCoordinate: Coordinate) {
        guard let userID = try? self.userRepository.fetchUUID() else { return }
        
        Task {
            let result = await self.journeyRepository.fetchJourneyList(userID: userID,
                                                                       minCoordinate: minCoordinate,
                                                                       maxCoordinate: maxCoordinate)
            switch result {
            case .success(let journeys):
                self.state.journeys.send(journeys)
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
}
