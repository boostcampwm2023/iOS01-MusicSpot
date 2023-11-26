//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Combine
import Foundation

import MSNetworking

public protocol JourneyRepository {
    func fetchJourneyList() async -> Result<[Journey], Error>
}

public struct Journey: Codable {
    
}

public struct JourneyRepositoryImplementation: JourneyRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.networking = MSNetworking(session: session)
    }
    
    // MARK: - Functions
    
    public func fetchJourneyList() async -> Result<[Journey], Error> {
        return await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.networking.request([Journey].self, router: JourneyRouter.journeyList)
                .sink { completion in
                    switch completion {
                    case .finished:
                        continuation.resume(returning: .failure(MSNetworkError.timeout))
                    case .failure(let error):
                        continuation.resume(returning: .failure(error))
                    }
                    cancellable?.cancel()
                } receiveValue: { journeys in
                    continuation.resume(returning: .success(journeys))
                    cancellable?.cancel()
                }
        }
    }
    
}
