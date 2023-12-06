//
//  MSKeychainStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct MSKeychainStorage {
    
    // MARK: - Initializer
    
    public init() { }
    
    // MARK: - Functions
    
    /// Keychain에 데이터를 추가합니다.
    ///
    /// 만약 값이 이미 존재한다면 업데이트하고, 존재하지 않는다면 새로 추가합니다.
    ///
    /// - Parameters:
    ///   - value: Keychain에 저장할 데이터 (`Data`)
    ///   - account: Keychain에 저장할 데이터에 대응되는 Key (`String`)
    public func set(value: Data, account: String) throws {
        if try self.exists(account: account) {
            try self.update(value: value, account: account)
        } else {
            try self.add(value: value, account: account)
        }
    }
    
    /// Keychain에서 account Key에 해당되는 데이터를 불러옵니다.
    ///
    /// Keychain에 값이 존재한다면 Optional로 불러오고, 존재하지 않는다면 에러를 방출합니다.
    ///
    /// - Parameters:
    ///   - account: Keychain에서 조회할 데이터에 대응되는 Key (`String`)
    /// - Returns: Keychain에 저장된 데이터
    public func get(account: String) throws -> Data? {
        if try self.exists(account: account) {
            return try self.fetch(account: account)
        } else {
            throw KeychainError.transactionError
        }
    }
    
    /// Keychain에 저장되어 있는 account Key에 대응되는 데이터를 삭제합니다.
    ///
    /// - Parameters:
    ///   - account: Keychain에서 삭제할 값에 대응되는 Key (`String`)
    public func delete(account: String) throws {
        if try self.exists(account: account) {
            return try self.remove(account: account)
        } else {
            throw KeychainError.transactionError
        }
    }
    
    /// Keychain에 저장된 모든 데이터를 삭제합니다.
    public func deleteAll() throws {
        for account in Accounts.allCases {
            try self.delete(account: account.rawValue)
        }
    }
    
}
