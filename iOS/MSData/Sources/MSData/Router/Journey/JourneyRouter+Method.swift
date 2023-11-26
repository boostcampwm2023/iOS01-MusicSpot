//
//  JourneyRouter+Method.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import MSNetworking

extension JourneyRouter {
    
    public var method: HTTPMethod {
        switch self {
        case .journeyList: return .get
        }
    }
    
}
