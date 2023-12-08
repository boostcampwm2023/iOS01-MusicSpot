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
import MSLogger
import MSUserDefaults

public final class HomeViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case fetchJourney(at: (minCoordinate: Coordinate, maxCoordinate: Coordinate))
    }
    
    public struct State {
        var journeys = CurrentValueSubject<[Journey], Never>([])
        
        public init() { }
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private let journeyRepository: JourneyRepository
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
            self.createNewUser()
        case .fetchJourney(at: (let minCoordinate, let maxCoordinate)):
            self.fetchJourneys(minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
        }
    }
}


// MARK: - Privates

private extension HomeViewModel {
    
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
    
    func createNewUser() {
        let isFirstLaunch = self.isFirstLaunch ? "앱이 처음 실행되었습니다." : "앱 첫 실행이 아닙니다."
        MSLogger.make(category: .userDefaults).log("\(isFirstLaunch)")
        
        guard self.isFirstLaunch else { return }
        
        Task {
            let result = await self.userRepository.createUser()
            switch result {
            case .success(let userInfo):
                MSLogger.make(category: .home).log("\(userInfo.userID) 유저가 생성되었습니다.")
                
                self.isFirstLaunch = false
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
}
