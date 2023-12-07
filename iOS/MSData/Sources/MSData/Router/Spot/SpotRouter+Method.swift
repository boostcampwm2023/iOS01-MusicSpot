//
//  SpotRouter+Method.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import MSNetworking

extension SpotRouter {
    
    public var method: HTTPMethod {
        switch self {
        case .uploadSpot: return .post
        case .downloadSpot: return .get
        }
    }
    
}
