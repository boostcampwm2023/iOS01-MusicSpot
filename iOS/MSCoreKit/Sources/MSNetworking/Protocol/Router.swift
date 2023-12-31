//
//  Router.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation
import UIKit

import MSLogger

public protocol Router {
    
    /// 기본 URL
    /// > Tip: `https://www.naver.com`
    var baseURL: String { get }
    /// 경로 URL
    /// > Tip: `/api`
    var pathURL: String? { get }
    /// HTTP Method
    /// > Tip: `.get`
    var method: HTTPMethod { get }
    /// HTTP Body
    /// > Tip: `StartJourneyRequestDTO()`
    var body: HTTPBody? { get }
    /// HTTP Header
    /// > Tip: `applicaton/json`
    var headers: HTTPHeaders? { get }
    /// HTTP Queries
    /// > Tip: `?userId=655efda2fdc81cae36d20650`
    var queries: [URLQueryItem]? { get }
    
    /// 최종적으로 사용되는 `URLRequest`
    func makeRequest(encoder: JSONEncoder) -> URLRequest?
    
}

extension Router {
    
    public func makeRequest(encoder: JSONEncoder) -> URLRequest? {
        var urlString = self.baseURL
        
        if let path = self.pathURL {
            urlString += "/\(path)"
        }
        
        guard var baseURLComponents = URLComponents(string: urlString) else { return nil }
        
        if let queries = self.queries, !queries.isEmpty {
            baseURLComponents.queryItems = self.queries
        }
        #if DEBUG
        MSLogger.make(category: .network).log("\(baseURLComponents)")
        #endif
        guard let url = baseURLComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        if let headers = self.headers {
            headers.forEach { key, value in
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let body = self.body {
            request.httpBody = body.data(encoder: encoder)
        }
        return request
    }
    
    public func fetchBaseURLFromPlist(from bundle: Bundle) -> String? {
        guard let url = bundle.url(forResource: "APIInfo", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            return nil
        }
        let urlString = dict["BaseURL"] as? String
        return urlString
    }
    
}
