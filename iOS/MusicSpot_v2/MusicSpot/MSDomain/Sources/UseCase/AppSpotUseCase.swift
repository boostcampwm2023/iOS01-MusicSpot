//
//  AppSpotUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

import Entity
import Repository

public final class AppSpotUseCase: SpotUseCase {
    // MARK: - Properties

    private let spotRepository: SpotRepository
    private let journeyRepository: JourneyRepository

    // MARK: - Initializer

    init(spotRepository: SpotRepository, journeyRepository: JourneyRepository) {
        self.spotRepository = spotRepository
        self.journeyRepository = journeyRepository
    }

    // MARK: - Functions

    public func fetchPhotos(of spot: Spot) throws -> AsyncStream<(Spot, Data)> {
        return self.spotRepository.fetchPhotos(of: spot)
    }

    @discardableResult
    public func recordNewSpot(_ spot: Spot) async throws -> Spot {
        let travelingJourney = try await self.journeyRepository.fetchTravelingJourney()

        self.spotRepository.addSpot(spot, to: consume travelingJourney)

        return spot
    }
}
