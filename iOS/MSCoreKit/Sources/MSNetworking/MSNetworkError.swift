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
