//
//  File.swift
//  
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
    
    let journeyRepository: JourneyRepository
    let userRepository: UserRepository
    
    @UserDefaultsWrapped(UserDefaultsKey.isFirstLaucnh, defaultValue: false)
    private var isFirstLaunch: Bool
    
    // MARK: - Initializer
    
    public init(journeyRepository: JourneyRepository, userRepository: UserRepository) {
        self.journeyRepository = journeyRepository
        self.userRepository = userRepository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            print("ViewNeedsLoaded")
        case .fetchJourney(at: (let minCoordinate, let maxCoordinate)):
            Task {
                let result = await self.journeyRepository.fetchJourneyList(minCoordinate: minCoordinate,
                                                                    maxCoordinate: maxCoordinate)
                switch result {
                case .success(let journeys):
                    self.state.journeys.send(
                        journeys.journeys.map { journeyDTO in
                            return Journey(dto: journeyDTO)
                        }
                    )
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
}

// MARK: - Privates

private extension HomeViewModel {
    
    func fetchUser() {
        #if DEBUG
        let isFirstLaunch = self.isFirstLaunch ? "앱이 처음 실행되었습니다." : "앱 첫 실행이 아닙니다."
        MSLogger.make(category: .userDefaults).log("\(isFirstLaunch)")
        #endif
        guard self.isFirstLaunch else { return }
        
        Task {
            let result = await self.userRepository.createUser()
            switch result {
            case .success(let userInfo):
                #if DEBUG
                MSLogger.make(category: .home).log("\(userInfo.userID) 유저가 생성되었습니다.")
                #endif
                
                self.isFirstLaunch = false
            case .failure(let error):
                MSLogger.make(category: .home).error("\(error)")
            }
        }
    }
    
}
