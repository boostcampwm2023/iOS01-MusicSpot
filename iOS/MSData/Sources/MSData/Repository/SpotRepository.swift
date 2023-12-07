//
//  SpotRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

import MSNetworking

public protocol SpotRepository {
    
    func fetchRecordingSpots() async -> Result<[SpotDTO], Error>
    func upload(spot: CreateSpotRequestDTO) async -> Result<Void, Error>
    
}

public struct SpotRepositoryImplementation: SpotRepository {
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    public func fetchRecordingSpots() async -> Result<[SpotDTO], Error> {
        
        #if DEBUG
        guard let jsonURL = Bundle.module.url(forResource: "MockSpot", withExtension: "json") else {
            return .failure((MSNetworkError.invalidRouter))
        }
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let spots = try decoder.decode([SpotDTO].self, from: jsonData)
            return .success(spots)
        } catch {
            print(error)
        }
        #else
        
        #endif
        
        return .failure(MSNetworkError.unknownResponse)
    }
    
    public func upload(spot: CreateSpotRequestDTO) async -> Result<Void, Error> {
        #if DEBUG
        return .success(())
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
