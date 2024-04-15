//
//  MSKeychainStorage+Error.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

extension MSKeychainStorage {
    
    public enum KeychainError: Error {
        
        case fetchError
        case creationError
        case transactionError
        
    }
    
}
