//
//  SpotRepositoryTests.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import XCTest
@testable import AppRepository
import Foundation
import SwiftData
@testable import DataSource
@testable import Entity

final class SpotRepositoryTests: XCTestCase {
    // MARK: - Properties

    private let sut = AppSpotRepository()

    // MARK: - Tests

    private var sut: AppSpotRepository!
    
    // MARK: - Setup
    
    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SpotLocalDataSource.self, configurations: config)
        let context = ModelContext(container)
        
        self.sut = AppSpotRepository(context: context)
    }

    // MARK: - Tests

    func test_SpotRepository_fetchPhotos() async throws {
        let spot = Spot(
            id: UUID().uuidString,
            coordinate: Coordinate(x: 12.0, y: 2.0),
            timestamp: .now,
            photoURLs: [
                URL(string: "https://picsum.photos/200")!,
                URL(string: "https://picsum.photos/300")!,
                URL(string: "https://picsum.photos/400")!,
                URL(string: "https://picsum.photos/600")!,
                URL(string: "https://picsum.photos/500")!
            ]
        )
        let stream = self.sut.fetchPhotos(of: spot)
        
        for try await (spot, photoData) in stream {
            print(spot)
            print("Size: \(photoData.count)")
        }
    }
}
