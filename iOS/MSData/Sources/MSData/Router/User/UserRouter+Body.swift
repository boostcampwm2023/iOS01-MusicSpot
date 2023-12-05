//
//  UserRouter+Body.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import MSNetworking

extension UserRouter {
    
    public var body: HTTPBody? {
        switch self {
        case .newUser(let dto):
            return HTTPBody(content: dto)
        }
    }
    
}

