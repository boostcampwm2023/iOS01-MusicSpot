//
//  Requestable.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public protocol Router {
    
    var baseURL: String { get }
    var pathURL: String { get }
    var method: HTTPMethod { get }
    var body: HTTPBody? { get }
    var headers: HTTPHeaders? { get }
    
    var request: URLRequest? { get }
    
}

extension Router {
    
    public var request: URLRequest? {
        guard let baseURL = URL(string: self.baseURL) else { return nil }
        let url = baseURL.appendingPathComponent(self.pathURL)
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        if let body = self.body {
            request.httpBody = body.data()
        }
        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
}
