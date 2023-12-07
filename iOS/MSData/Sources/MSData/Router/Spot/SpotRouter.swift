//
//  SpotRouter.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSNetworking

public enum SpotRouter: Router {
    
    /// Spot을 기록합니다.
    case upload(spot: CreateSpotRequestDTO, id: UUID)
    /// Spot을 받아옵니다.
    case downloadSpot
    
}
