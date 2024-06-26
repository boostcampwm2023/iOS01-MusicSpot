//
//  AppSpotUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

import Entity
import MSError
import Repository

public final class AppSpotUseCase: SpotUseCase {
    // MARK: - Properties

    private let spotRepository: SpotRepository

    // MARK: - Initializer

    init(spotRepository: SpotRepository) {
        self.spotRepository = spotRepository
    }

    // MARK: - Functions

    public func fetchPhotos(of spot: Spot) throws -> AsyncStream<(Spot, Data)> {
        return self.spotRepository.fetchPhotos(of: spot)
    }

    @discardableResult
    public func recordNewSpot(_ spot: Spot, to journey: Journey) async throws(SpotError) -> Spot {
        self.spotRepository.addSpot(spot, to: consume journey)

        return spot
    }
}
