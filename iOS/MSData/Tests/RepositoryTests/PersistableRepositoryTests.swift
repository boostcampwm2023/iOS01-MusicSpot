//
//  PersistableRepositoryTests.swift
//  
//
//  Created by 전민건 on 12/11/23.
//

import XCTest
@testable import MSData

final class PersistableRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private let journeyRepository = JourneyRepositoryImplementation()
    
    // MARK: - Tests

    func test_Spot저장() {
        self.journeyRepository.saveToLocal(value: <#T##Codable#>)
    }
    
    func test_RecordingJourney_하위요소가_아닌_것들_저장_실패() {
        self.journeyRepository.saveToLocal(value: Int())
    }
    
    func test_RecordingJourney_반환_성공() {
        
        
    }

}
