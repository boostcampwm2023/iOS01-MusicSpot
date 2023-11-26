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
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String else {
            fatalError("BaseURL을 가져오는데 실패했습니다.")
        }
        return urlString
    }
    
    public var pathURL: String {
        switch self {
        case .journeyList: return ""
        }
    }
    
}
