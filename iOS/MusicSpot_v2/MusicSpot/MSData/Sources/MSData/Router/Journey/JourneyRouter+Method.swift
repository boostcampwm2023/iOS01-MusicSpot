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
        case .startJourney: return .post
        case .endJourney: return .post
        case .recordCoordinate: return .post
        case .checkJourney: return .get
        case .loadLastJourney: return .get
        case .deleteJourney: return .delete
        }
    }
}
