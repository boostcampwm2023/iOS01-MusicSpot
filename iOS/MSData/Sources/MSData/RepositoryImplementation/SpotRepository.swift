//
//  SpotRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

import MSDomain
import MSExtension
import MSImageFetcher
import MSNetworking
import MSLogger
import MSPersistentStorage

public struct SpotRepositoryImplementation: SpotRepository {
    
    // MARK: - Properties
    
    private let networking: MSNetworking
    public let storage: MSPersistentStorage
    
    // MARK: - Initializer
    
    public init(session: URLSession = URLSession(configuration: .default),
                persistentStorage: MSPersistentStorage = FileManagerStorage()) {
        self.networking = MSNetworking(session: session)
        self.storage = persistentStorage
    }
    
    // MARK: - Functions
    
    public func fetchRecordingSpots() async -> Result<[Spot], Error> {
        #if MOCK
        guard let jsonURL = Bundle.module.url(forResource: "MockSpot", withExtension: "json") else {
            return .failure((MSNetworkError.invalidRouter))
        }
        do {
            let jsonData = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let spots = try decoder.decode([SpotDTO].self, from: jsonData)
            return .success(spots.map { $0.toDomain() })
        } catch {
            MSLogger.make(category: .network).error("/(error)")
        }
        return .failure(MSNetworkError.unknownResponse)
        #else
        let router = SpotRouter.downloadSpot
        let result = await self.networking.request([SpotDTO].self, router: router)
        switch result {
        case .success(let spot):
            #if DEBUG
            MSLogger.make(category: .network).debug("성공적으로 다운로드하였습니다.")
            #endif
            return .success(spot.map { $0.toDomain() })
        case .failure(let error):
            MSLogger.make(category: .network).error("\(error): 다운로드에 실패하였습니다.")
            return .failure(error)
        }
        #endif
    }
    
    public func upload(spot: RequestableSpot) async -> Result<Spot, Error> {
        let spot = CreateSpotRequestDTO(journeyId: spot.journeyID,
                                        coordinate: CoordinateDTO(spot.coordinate),
                                        timestamp: spot.timestamp,
                                        photoData: spot.photoData)
        
        let router = SpotRouter.upload(spot: spot, id: UUID())
        let result = await self.networking.request(SpotDTO.self, router: router)
        switch result {
        case .success(let spot):
            #if DEBUG
            MSLogger.make(category: .network).debug("성공적으로 업로드하였습니다.")
            #endif
            RecordingJourneyStorage.shared.record([spot], keyPath: \.spots)
            return .success(spot.toDomain())
        case .failure(let error):
            MSLogger.make(category: .network).error("\(error): 업로드에 실패하였습니다.")
            return .failure(error)
        }
    }
    
    @discardableResult
    public func fetchSpotPhoto(from photoURL: URL) async -> Data? {
        return await MSImageFetcher.shared.fetchImage(from: photoURL, forKey: photoURL.paath())
    }
            
}
