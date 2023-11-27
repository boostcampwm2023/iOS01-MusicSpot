//
//  MSNetworkError.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

public enum MSNetworkError: Error {
    
    case invalidRouter
    case unknownResponse
    case invalidStatusCode(statusCode: Int, description: String)
    case timeout
    
}

extension MSNetworkError: Equatable {
    
    public static func == (lhs: MSNetworkError, rhs: MSNetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRouter, .invalidRouter):
            return true
        case (.unknownResponse, .unknownResponse):
            return true
        case let (.invalidStatusCode(lhsStatusCode, _), .invalidStatusCode(rhsStatusCode, _)):
            return lhsStatusCode == rhsStatusCode
        case (.timeout, .timeout):
            return true
        default:
            return false
        }
    }
    
}
