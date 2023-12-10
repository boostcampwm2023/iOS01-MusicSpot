//
//  PersistableRepositoryTests.swift
//  MSData
//
//  Created by 전민건 on 12/11/23.
//

import XCTest
@testable import MSData
@testable import MSDomain

final class PersistableRepositoryTests: XCTestCase {
    
    // MARK: - Properties
    
    private let journeyRepository = JourneyRepositoryImplementation()
    
    // MARK: - Tests

    func test_Spot저장_성공() {
        let coordinate = Coordinate(latitude: 10, longitude: 10)
        let url = URL(string: "/../")!
        
        let spot = Spot(coordinate: coordinate, timestamp: .now, photoURL: url)
        
        XCTAssertTrue(self.journeyRepository.saveToLocal(value: SpotDTO(spot)))
    }
    
    func test_RecordingJourney_하위요소가_아닌_것들_저장_실패() {
        XCTAssertFalse(self.journeyRepository.saveToLocal(value: Int()))
    }
    
    func test_RecordingJourney_반환_성공() {
        let url = URL(string: "/../")!
        
        let id = "id"
        let startTimestamp = Date.now
        let coordinate = Coordinate(latitude: 5, longitude: 5)
        let spot = Spot(coordinate: coordinate, timestamp: .now, photoURL: url)
        
        self.journeyRepository.saveToLocal(value: id)
        self.journeyRepository.saveToLocal(value: Date.now)
        self.journeyRepository.saveToLocal(value: SpotDTO(spot))
        self.journeyRepository.saveToLocal(value: CoordinateDTO(coordinate))
        
        guard let loadedJourney = self.journeyRepository.loadJourneyFromLocal() else {
            XCTFail("load 실패")
            return
        }
        
        XCTAssertEqual(loadedJourney.id, id)
        XCTAssertEqual(loadedJourney.startTimestamp.description, startTimestamp.description)
        XCTAssertEqual(loadedJourney.spots.description, [spot].description)
        XCTAssertEqual(loadedJourney.coordinates, [coordinate])
    }

}
