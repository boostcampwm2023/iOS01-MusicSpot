//
//  Requestable.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public protocol Router {
    
    var baseURL: APIbaseURL { get }
    var pathURL: APIpathURL { get }
    var method: HTTPMethod { get }
    var body: HTTPBody { get }
    
    func asURLRequest() -> URLRequest?
    
}
