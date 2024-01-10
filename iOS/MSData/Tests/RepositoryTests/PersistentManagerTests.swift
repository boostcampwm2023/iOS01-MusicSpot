//
//  PersistableRepositoryTests.swift
//  MSData
//
//  Created by 전민건 on 12/11/23.
//

import XCTest
@testable import MSData
@testable import MSDomain
@testable import MSPersistentStorage

final class PersistentManagerTests: XCTestCase {
    
    // MARK: - Properties
    
    private let storage = FileManagerStorage()
    private var recordingJourney = RecordingJourneyStorage.shared
    
    override func tearDown() async throws {
        try self.recordingJourney.finish()
    }
    
    // MARK: - Tests

    func test_Spot저장_성공() {
        let coordinate = Coordinate(latitude: 10, longitude: 10)
        let url = URL(string: "/../")!
        
        self.recordingJourney.start(initialData: RecordingJourney(id: UUID().uuidString,
                                                                  startTimestamp: .now,
                                                                  spots: [],
                                                                  coordinates: []))
        
        let spot = Spot(coordinate: coordinate, timestamp: .now, photoURL: url)
        XCTAssertTrue(self.recordingJourney.record([SpotDTO(spot)], keyPath: \.spots))
    }
    
    func test_RecordingJourney_반환_성공() {
        let url = URL(string: "/../")!
        
        let id = "id"
        let startTimestamp = Date.now
        let coordinate = Coordinate(latitude: 5, longitude: 5)
        let spot = Spot(coordinate: coordinate, timestamp: .now, photoURL: url)
        
        self.recordingJourney.start(initialData: RecordingJourney(id: id,
                                                                  startTimestamp: startTimestamp,
                                                                  spots: [],
                                                                  coordinates: []))
        self.recordingJourney.record([SpotDTO(spot)], keyPath: \.spots)
        self.recordingJourney.record([CoordinateDTO(coordinate)], keyPath: \.coordinates)
        
        guard let loadedJourney = self.recordingJourney.currentState else {
            XCTFail("load 실패")
            return
        }
        
        XCTAssertEqual(loadedJourney.id, id)
        XCTAssertEqual(loadedJourney.startTimestamp.description, startTimestamp.description)
        XCTAssertEqual(loadedJourney.spots.description, [spot].description)
        XCTAssertEqual(loadedJourney.coordinates, [coordinate])
    }

}
