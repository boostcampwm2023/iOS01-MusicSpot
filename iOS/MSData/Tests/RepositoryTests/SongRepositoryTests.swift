//
//  SongRepositoryTests.swift
//  MSData
//
//  Created by 이창준 on 2023.12.03.
//

import XCTest
@testable import MSData

final class SongRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private let songRepository = SongRepositoryImplementation()
    
    // MARK: - Tests

    func testExample() throws {
        
        let expectation = XCTestExpectation()
        
        Task {
            let result = await self.songRepository.fetchSongList()
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
