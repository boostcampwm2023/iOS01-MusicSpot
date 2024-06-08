//
//  AppSpotUseCase.swift
//  UseCase
//
//  Created by 이창준 on 6/6/24.
//

import Foundation

import Entity

public final class AppSpotUseCase: SpotUseCase {
    public func fetchSpots(of journey: Journey) async throws -> [Spot] {
        []
    }

    public func fetchPhotos(of spot: Spot) async throws -> AsyncStream<(Spot, Data)> {
        .init { _ in }
    }

    public func recordNewSpot(_ spot: Spot) async throws -> Spot {
        Spot(coordinate: Coordinate(latitude: .zero, longitude: .zero), timestamp: .now, photoURLs: [])
    }
}
