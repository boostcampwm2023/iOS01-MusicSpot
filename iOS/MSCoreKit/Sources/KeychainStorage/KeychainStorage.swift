//
//  KeychainStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSPersistentStorage

public struct KeychainStorage: MSPersistentStorage {
    
    // MARK: - Properties
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
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
    @discardableResult
    public func set<T: Codable>(value: T, forKey key: String, subpath: String? = nil) throws -> T? {
        let encodedValue = try self.encoder.encode(value)
        
        do {
            if try self.exists(account: key) {
                try self.update(value: encodedValue, account: key)
            } else {
                try self.add(value: encodedValue, account: key)
            }
            return value
        } catch {
            return nil
        }
    }
    
    /// Keychain에서 account Key에 해당되는 데이터를 불러옵니다.
    ///
    /// Keychain에 값이 존재한다면 Optional로 불러오고, 존재하지 않는다면 에러를 방출합니다.
    ///
    /// - Parameters:
    ///   - account: Keychain에서 조회할 데이터에 대응되는 Key (`String`)
    /// - Returns: Keychain에 저장된 데이터
    public func get<T: Codable>(_ type: T.Type, forKey key: String, subpath: String?) throws -> T? {
        if try self.exists(account: key) {
            guard let value = try self.fetch(account: key) else {
                return nil
            }
            return try self.decoder.decode(T.self, from: value)
        } else {
            throw KeychainError.transactionError
        }
    }
    
    /// Keychain에 저장되어 있는 account Key에 대응되는 데이터를 삭제합니다.
    ///
    /// - Parameters:
    ///   - account: Keychain에서 삭제할 값에 대응되는 Key (`String`)
    public func delete(forKey key: String, subpath: String? = nil) throws {
        if try self.exists(account: key) {
            return try self.remove(account: key)
        } else {
            throw KeychainError.transactionError
        }
    }
    
    /// Keychain에 저장된 모든 데이터를 삭제합니다.
    public func deleteAll(subpath: String? = nil) throws {
        for account in Accounts.allCases where try self.exists(account: account.rawValue) {
            try self.delete(forKey: account.rawValue)
        }
    }
    
}
