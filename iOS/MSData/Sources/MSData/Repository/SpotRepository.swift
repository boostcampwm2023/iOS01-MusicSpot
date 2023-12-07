//
//  SpotRepository.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation

import MSNetworking

// 임시 model_ domain 생성 시 삭제

public struct RequestableSpotDTO {
    private let journeyID: UUID
    private let coordinate: [Double]
    private let imageData: Data
    
    init(journeyID: UUID, coordinate: [Double], imageData: Data) {
        self.journeyID = journeyID
        self.coordinate = coordinate
        self.imageData = imageData
    }
}

//

public protocol SpotRepository {
    
    func fetchRecordingSpots() async -> Result<[SpotDTO], Error>
    func upload(spot: RequestableSpotDTO) async -> Result<Void, Error>
    
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
    
    public func upload(spot: RequestableSpotDTO) async -> Result<Void, Error> {
        #if DEBUG
        return .success(())
        #else
        
        #endif
    }
            
}
