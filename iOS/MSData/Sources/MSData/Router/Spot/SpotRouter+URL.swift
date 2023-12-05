//
//  SpotRouter+URL.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSNetworking

extension SpotRouter {
    
    public var baseURL: String {
        let urlString = self.fetchBaseURLFromPlist(from: Bundle.module)
        
        return urlString.appending("/spot")
    }
    
    public var pathURL: String {
        switch self {
        case .createSpot: return "create"
        case .findSpot: return "find"
        }
    }
    
}

