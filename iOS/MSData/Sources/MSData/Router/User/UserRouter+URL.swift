//
//  UserRouter+URL.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSNetworking

extension UserRouter {
    
    public var baseURL: String {
        guard let urlString = self.fetchBaseURLFromPlist(from: Bundle.module) else {
            return ""
        }
        
        return urlString.appending("/user")
    }
    
    public var pathURL: String? {
        switch self {
        case .newUser: return nil
        }
    }
    
}


