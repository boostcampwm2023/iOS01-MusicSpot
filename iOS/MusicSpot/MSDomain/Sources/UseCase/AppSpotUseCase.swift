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

    // MARK: Lifecycle

    // MARK: - Initializer

    init(spotRepository: SpotRepository) {
        self.spotRepository = spotRepository
    }

    // MARK: Public

    // MARK: - Functions

    public func fetchPhotos(of spot: Spot) throws -> AsyncThrowingStream<(spot: Spot, photoData: Data), Error> {
        spotRepository.fetchPhotos(of: spot)
    }

    @discardableResult
    public func recordNewSpot(_ spot: Spot, to journey: Journey) async throws(SpotError) -> Spot { // swiftlint:disable:this all
        do {
            try spotRepository.addSpot(spot, to: consume journey)
            return spot
        } catch {
            throw .repositoryError(error)
        }
    }

    // MARK: Private

    // MARK: - Properties

    private let spotRepository: SpotRepository
}
