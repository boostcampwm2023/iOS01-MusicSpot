//
//  JourneyRepository.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Combine
import Foundation

import MSDomain
import MSNetworking

public protocol JourneyRepository {
    
    func fetchJourneyList(minCoordinate: Coordinate,
                          maxCoordinate: Coordinate) async -> Result<CheckJourneyResponseDTO, Error>
    
}

public struct JourneyRepositoryImplementation: JourneyRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.networking = MSNetworking(session: session)
    }
    
    // MARK: - Functions
    
    public func fetchJourneyList(minCoordinate: Coordinate,
                                 maxCoordinate: Coordinate) async -> Result<CheckJourneyResponseDTO, Error> {
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
            let journeys = try decoder.decode(CheckJourneyResponseDTO.self, from: jsonData)
            return .success(journeys)
        } catch {
            return .failure(error)
        }
        #else
        let router = JourneyRouter.checkJourney(userID: UUID(),
                                                minCoordinate: CoordinateDTO(minCoordinate),
                                                maxCoordinate: CoordinateDTO(maxCoordinate))
        let result = await self.networking.request(CheckJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let journeys):
            return .success(journeys)
        case .failure(let error):
            return .failure(error)
        }
        #endif
    }
    
}
