//
//  MSRouter.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public struct RouterType {
    
    private var encodable: Encodable?
    
    // 기능별 MSRouter
//    public var getJourney: MSRouter {
//        MSRouter(baseURL: .none, pathURL: .none, method: .get, body: HTTPBody(content: encodable))
//    }
//    public var getPerson: MSRouter {
//        MSRouter(baseURL: .none, pathURL: .none, method: .get, body: HTTPBody(content: encodable))
//    }
    
}

public struct MSRouter: Router {

    public let baseURL: String
    public let pathURL: String
    public let method: HTTPMethod
    public var headers: HTTPHeaders?
    public var body: HTTPBody?
    
    func asURLRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + pathURL) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
//        request.httpBody = body.contentToData()
        
        return request
    }
    
}
