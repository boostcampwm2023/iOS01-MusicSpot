//
//  Session.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public protocol Session {
    
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    
}

extension URLSession: Session {
    
}
