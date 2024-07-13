//
//  SpotRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol SpotRepository {
    typealias PhotoWithSpot = (spot: Spot, photoData: Data)

    func addSpot(_ spot: Spot, to journey: Journey) throws
    func fetchPhotos(of spot: Spot) -> AsyncThrowingStream<PhotoWithSpot, Error>
}
