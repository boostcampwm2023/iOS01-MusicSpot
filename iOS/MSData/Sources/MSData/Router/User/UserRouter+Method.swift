//
//  UserRouter+Method.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import MSNetworking

extension UserRouter {
    
    public var method: HTTPMethod {
        switch self {
        case .newUser: return .post
        }
    }
    
}
