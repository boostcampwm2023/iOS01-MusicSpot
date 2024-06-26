//
//  AppSpotRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/11/24.
//

import Foundation

import Entity
import Repository

public final class AppSpotRepository: SpotRepository {
    public func addSpot(_ spot: Spot, to journey: Journey) {
        //
    }
    
    public func fetchPhotos(of spot: Spot) -> AsyncStream<(Spot, Data)> {
        return .init { _ in
            //
        }
    }
}
