//
//  MSNetworkError.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation

// MARK: - MSNetworkError

public enum MSNetworkError: Error {
    case invalidRouter
    case unknownResponse
    case invalidStatusCode(statusCode: Int, description: String)
    case timeout
    case unknownChildTask
}

// MARK: Equatable

extension MSNetworkError: Equatable {
    public static func == (lhs: MSNetworkError, rhs: MSNetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidRouter, .invalidRouter):
            true
        case (.unknownResponse, .unknownResponse):
            true
        case (.invalidStatusCode(let lhsStatusCode, _), .invalidStatusCode(let rhsStatusCode, _)):
            lhsStatusCode == rhsStatusCode
        case (.timeout, .timeout):
            true
        case (.unknownChildTask, .unknownChildTask):
            true
        default:
            false
        }
    }
}
