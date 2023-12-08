//
//  SpotRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

import MSNetworking
import MSLogger

public protocol SpotRepository {
    
    func fetchRecordingSpots() async -> Result<[SpotDTO], Error>
    func upload(spot: CreateSpotRequestDTO) async -> Result<SpotDTO, Error>
    
}

public struct SpotRepositoryImplementation: SpotRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default)) {
        self.networking = MSNetworking(session: session)
    }
    
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
        return .failure(MSNetworkError.unknownResponse)
        #else
        let router = SpotRouter.downloadSpot
        let result = await self.networking.request([SpotDTO].self, router: router)
        switch result {
        case .success(let spot):
            MSLogger.make(category: .network).debug("성공적으로 다운로드하였습니다.")
            return .success(spot)
        case .failure(let error):
            MSLogger.make(category: .network).debug("\(error): 다운로드에 실패하였습니다.")
            return .failure(error)
        }
        #endif
    }
    
    public func upload(spot: CreateSpotRequestDTO) async -> Result<SpotDTO, Error> {
//        #if DEBUG
//        return .success()
//        #else
        let router = SpotRouter.upload(spot: spot, id: UUID())
        let result = await self.networking.request(SpotDTO.self, router: router)
        switch result {
        case .success(let spot):
            MSLogger.make(category: .network).debug("성공적으로 업로드하였습니다.")
            return .success(spot)
        case .failure(let error):
            MSLogger.make(category: .network).debug("\(error): 업로드에 실패하였습니다.")
            return .failure(error)
        }
//        #endif
    }
            
}
