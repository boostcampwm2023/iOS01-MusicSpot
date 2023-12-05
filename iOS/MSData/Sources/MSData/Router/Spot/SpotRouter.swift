//
//  SpotRouter.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import MSNetworking

public enum SpotRouter: Router {
    
    /// Spot을 기록합니다.
    case createSpot
    /// Spot ID로 이미지를 조회합니다.
    case findSpot
    
}
