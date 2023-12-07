//
//  SpotRouter+Header.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSNetworking

extension SpotRouter {
    
    public var headers: HTTPHeaders? {
        switch self {
        case .upload(_, let id):
            return [
                (key: "Content-Type",
                 value: "multipart/form-data; boundary=Boundary-\(id.uuidString)")
            ]
        default:
            return [
                (key: "Content-Type", value: "application/json")
            ]
        }
    }
    
}
