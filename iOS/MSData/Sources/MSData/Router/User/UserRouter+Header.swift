//
//  UserRouter+Header.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import MSNetworking

extension UserRouter {
    
    public var headers: HTTPHeaders? {
        switch self {
        default:
            return [
                (key: "Content-Type", value: "application/json")
            ]
        }
    }
    
}
