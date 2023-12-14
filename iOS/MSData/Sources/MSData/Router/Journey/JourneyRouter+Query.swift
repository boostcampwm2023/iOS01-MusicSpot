//
//  JourneyRouter+Query.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSNetworking

extension JourneyRouter {
    
    public var queries: [URLQueryItem]? {
        switch self {
        case .checkJourney(let userID, let minCoordinate, let maxCoordinate):
            return [
                URLQueryItem(name: "userId", value: "\(userID)"),
                URLQueryItem(name: "minCoordinate", value: "\(minCoordinate.latitude)"),
                URLQueryItem(name: "minCoordinate", value: "\(minCoordinate.longitude)"),
                URLQueryItem(name: "maxCoordinate", value: "\(maxCoordinate.latitude)"),
                URLQueryItem(name: "maxCoordinate", value: "\(maxCoordinate.longitude)")
            ]
        case let .loadLastJourney(userID):
            return [
                URLQueryItem(name: "userId", value: "\(userID)")
            ]
        default: return nil
        }
    }
    
}
