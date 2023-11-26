//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import MSNetworking

public protocol JourneyRepository {
    
}

public struct JourneyRepositoryImpl: JourneyRepository {
    
    // MARK: - Properties
    
    private let router: JourneyRouter
    
    // MARK: - Initializer
    
    public init(router: JourneyRouter) {
        self.router = router
    }
    
}
