//
//  JourneyRouter+Header.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import MSNetworking

extension JourneyRouter {
    
    public var headers: HTTPHeaders? {
        switch self {
        case .journeyList: return nil
        case .spot: return nil
        }
    }
    
}
