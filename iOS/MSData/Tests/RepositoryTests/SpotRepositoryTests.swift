//
//  SpotRepositoryTests.swift
//  
//
//  Created by 이창준 on 2023.12.04.
//

import XCTest
@testable import MSData

final class SpotRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private let sut = SpotRepositoryImplementation()
    
    // MARK: - Tests

    func test_SpotResponseDTO_디코딩_성공() throws {
        
        let expectation = XCTestExpectation()
        
        Task {
            let result = await self.sut.fetchRecordingSpots()
            switch result {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

}
