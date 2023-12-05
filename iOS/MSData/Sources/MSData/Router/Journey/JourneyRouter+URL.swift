//
//  JourneyRouter+BaseURL.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Foundation

import MSNetworking

extension JourneyRouter {
    
    public var baseURL: String {
        guard let url = Bundle.module.url(forResource: "APIInfo", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let urlString = dict["BaseURL"] as? String else {
            fatalError("BaseURL을 가져오는데 실패했습니다.")
        }
        
        return urlString.appending("/journey")
    }
    
    public var pathURL: String {
        switch self {
        case .startJourney: return "start"
        case .endJourney: return "end"
        case .recordJourney: return "record"
        case .checkJourney: return "check"
        case .loadLastJourney: return "loadLastData"
        }
    }
    
}
