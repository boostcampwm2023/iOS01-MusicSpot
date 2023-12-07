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
    func uploadSpot() async -> Result<SpotDTO, Error>
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
        #endif
        
        return .failure(MSNetworkError.unknownResponse)
    }
    
    public func uploadSpot() async -> Result<SpotDTO, Error> {
        <#code#>
    }
    
}
