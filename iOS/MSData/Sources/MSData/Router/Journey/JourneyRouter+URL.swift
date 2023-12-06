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
        guard let urlString = self.fetchBaseURLFromPlist(from: Bundle.module) else {
            fatalError("APIInfo.plist 파일을 읽을 수 없습니다.")
        }
        
        return urlString + "/journey"
    }
    
    public var pathURL: String? {
        switch self {
        case .startJourney: return "start"
        case .endJourney: return "end"
        case .recordJourney: return "record"
        case .checkJourney: return "check"
        case .loadLastJourney: return "loadLastData"
        }
    }
    
}
