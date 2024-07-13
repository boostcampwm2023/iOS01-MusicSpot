//
//  SpotRepositoryTests.swift
//  MSData
//
//  Created by 이창준 on 2023.12.04.
//

import Foundation
import SwiftData
import XCTest
@testable import AppRepository
@testable import DataSource
@testable import Entity

final class SpotRepositoryTests: XCTestCase {

    // MARK: Internal

    // MARK: - Setup

    override func setUp() async throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SpotLocalDataSource.self, configurations: config)
        let context = ModelContext(container)

        sut = AppSpotRepository(context: context)
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
                URL(string: "https://picsum.photos/500")!,
            ])
        let stream = sut.fetchPhotos(of: spot)

        for try await (spot, photoData) in stream {
            print(spot)
            print("Size: \(photoData.count)")
        }
    }

    // MARK: Private

    // MARK: - Properties

    private let sut = AppSpotRepository()

    // MARK: - Tests

    private var sut: AppSpotRepository!

}
