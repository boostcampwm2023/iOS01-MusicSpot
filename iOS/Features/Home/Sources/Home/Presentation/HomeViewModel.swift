//
//  File.swift
//  
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSConstants
import MSData
import MSLogger
import MSUserDefaults

public final class HomeViewModel {
    
    public enum Action {
        case viewNeedsLoaded
    }
    
    public struct State {
        
        public init() { }
    }
    
    // MARK: - Properties
    
    public var state = State()
    
    private let repository: UserRepository
    
    @UserDefaultsWrapped(UserDefaultsKey.isFirstLaucnh, defaultValue: false)
    private var isFirstLaunch: Bool
    
    // MARK: - Initializer
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            self.fetchUser()
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
            let result = await self.repository.createUser()
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
