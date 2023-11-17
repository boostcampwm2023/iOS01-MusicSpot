//
//  Router.swift
//
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

struct RouterType {
    
    private var encodable: Encodable?
    
    //기능별 Router
    var getJourney: Router {
        Router(baseURL: .none, pathURL: .none, method: .get, body: HTTPBody(content: encodable))
    }
    var getPerson: Router {
        Router(baseURL: .none, pathURL: .none, method: .get, body: HTTPBody(content: encodable))
    }
    
}

struct Router: Requestable {
    
    let baseURL: APIbaseURL
    let pathURL: APIpathURL
    let method: HTTPMethod
    var body: HTTPBody
    
    func asURLRequest() -> URLRequest? {
        guard let url = URL(string: baseURL.rawValue + pathURL.rawValue) else {
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body.contentToData()
        
        return request
    }
    
}
