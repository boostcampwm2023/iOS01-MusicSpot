//
//  SpotRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol SpotRepository {
    func addSpot(_ spot: Spot, to journey: Journey)
    func fetchPhotos(of spot: Spot) -> AsyncStream<(Spot, Data)>
}
