//
//  NavigateMapRepository.swift
//  MSData
//
//  Created by 윤동주 on 12/3/23.
//

import Combine
import Foundation

import MSNetworking

public protocol NavigateMapRepository {
    func fetchJourneyList() async -> Result<[JourneyDTO], Error>
}

public struct NavigateMapRepositoryImplementation: NavigateMapRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.networking = MSNetworking(session: session)
    }
    
    // MARK: - Functions
    
    public func fetchJourneyList() async -> Result<[JourneyDTO], Error> {
        #if DEBUG
        guard let jsonURL = Bundle.module.url(forResource: "MockJourney", withExtension: "json") else {
            return .failure((MSNetworkError.invalidRouter))
        }
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            let journeys = try decoder.decode([JourneyDTO].self, from: jsonData)
            return .success(journeys)
        } catch {
            print(error)
        }
        #else
        return await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.networking.request([JourneyDTO].self, router: JourneyRouter.checkJourney)
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
        #endif
        
        return .failure(MSNetworkError.unknownResponse)
    }
    
}