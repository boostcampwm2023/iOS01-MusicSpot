//
//  MockMSNetworking.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation
import Combine
@testable import struct MSNetworking.JourneyDTO
@testable import struct MSNetworking.JourneyMetadataDTO

public class MockMSNetworking {
    
    var expectedSuccessJourneyGetPublisher: Result<Data, any Error>.Publisher {
        let journey = JourneyDTO(JourneyIdentifier: UUID(),
                                 title: "",
                                 metaData: JourneyMetadataDTO(date: Date()),
                                 spots: [],
                                 coordinates: [],
                                 song: nil,
                                 lineColor: "")
        
        guard let jsonData = try? JSONEncoder().encode(journey) else {
            return Just(Data()).setFailureType(to: Error.self)
        }

        let request = Just(jsonData)
            .setFailureType(to: Error.self)

        return request
    }
    
    func request<T: Decodable>(mockRouter: MockRouter, type: T.Type) -> AnyPublisher<T, Error> {
        
        var publisher: Result<Data, any Error>.Publisher
        
        switch mockRouter {
        case .getJourney:
            publisher = expectedSuccessJourneyGetPublisher
        }
        
        return publisher.tryMap { result -> T in
                let value = try JSONDecoder().decode(T.self, from: result)
                return value
            }
            .eraseToAnyPublisher()
    }
    
}
