//
//  MSNetworkingTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import XCTest
import Combine
@testable import struct MSNetworking.JourneyDTO

final class MSNetworkingTests: XCTestCase {
    private let mockNetworking = MockMSNetworking()
    private var subscriber: Set<AnyCancellable> = []
    
    func test_get_JourneyDTO_성공() {
        //Arrange
        let getJourneyRouter = MockRouterType().getJourney
        
        //Act
        mockNetworking.request(mockRouter: getJourneyRouter, type: JourneyDTO.self)
            .sink { response in
                switch response {
                case .failure:
                    XCTFail("no response")
                default:
                    return
                }
            } receiveValue: { JourneyDTO in
                
                //Assert
                XCTAssertNotNil(JourneyDTO)
            }
            .store(in: &subscriber)
    }
            
}
