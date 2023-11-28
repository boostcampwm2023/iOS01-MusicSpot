//
//  ImageRouter.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.11.28.
//

import Foundation

public struct ImageRouter: Router {
    
    // MARK: - Properties
    
    public var baseURL: String
    
    public var pathURL: String
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var body: HTTPBody?
    
    public var headers: HTTPHeaders?
    
    // MARK: - Initializer
    
    public init(baseURL: String,
                pathURL: String,
                body: HTTPBody? = nil,
                headers: HTTPHeaders? = nil) {
        self.baseURL = baseURL
        self.pathURL = pathURL
        self.body = body
        self.headers = headers
    }
    
}
