//
//  JourneyRouter+Body.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import MSNetworking

extension JourneyRouter {
    
    public var body: HTTPBody? {
        switch self {
        case let .startJourney(dto):
            return HTTPBody(content: dto)
        case let .endJourney(dto):
            return HTTPBody(content: dto)
        case let .recordCoordinate(dto):
            return HTTPBody(content: dto)
        case let .deleteJourney(dto):
            return HTTPBody(content: dto)
        default: return nil
        }
    }
    
}
