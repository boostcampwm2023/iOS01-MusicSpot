//
//  MSKeychainStorage+Transaction.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

import MSLogger

extension MSKeychainStorage {
    /// Keychain으로부터 데이터를 불러옵니다.
    /// - Parameters:
    ///   - account: 가져올 키체인의 Key (`String`)
    func fetch(account: String) throws -> Data? {
        var result: AnyObject?

        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: KeychainConstants.service,
            kSecReturnData: true
        ] as NSDictionary, &result)

        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.fetchError
        }
    }

    /// Keychain에 데이터를 저장합니다.
    /// - Parameters:
    ///   - value: 저장할 값 (`Data`)
    ///   - account: 저장할 값에 대응되는 Key (`String`)
    func add(value: Data, account: String) throws {
        let status = SecItemAdd([
            kSecClass: kSecClassGenericPassword, // 데이터 종류
            kSecAttrAccount: account, // 데이터 키
            kSecValueData: value, // 데이터 밸류
            kSecAttrService: KeychainConstants.service
        ] as NSDictionary, nil)

        guard status == errSecSuccess else {
            throw KeychainError.transactionError
        }
    }

    /// Keychain에 있는 데이터를 업데이트합니다.
    /// - Parameters:
    ///   - value: 업데이트할 값
    ///   - account: 업데이트할 값에 대응되는 Key 값
    func update(value: Data, account: String) throws {
        let status = SecItemUpdate([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: KeychainConstants.service
        ] as NSDictionary, [
            kSecValueData: value
        ] as NSDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.transactionError
        }
    }

    /// Keychain에 있는 데이터를 삭제합니다.
    /// - Parameters:
    ///   - account: 삭제할 값에 대응되는 Key 값
    func remove(account: String) throws {
        let status = SecItemDelete([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: KeychainConstants.service
        ] as NSDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.transactionError
        }
    }

    /// Keychain에 account에 대응되는 값이 존재하는지 확인합니다.
    /// - Parameters:
    ///   - account: 조회할 Key 값
    func exists(account: String) throws -> Bool {
        let status = SecItemCopyMatching([
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: account,
            kSecAttrService: KeychainConstants.service,
            kSecReturnData: false
        ] as NSDictionary, nil)

        switch status {
        case errSecSuccess:
            MSLogger.make(category: .keychain).log("\(account)의 키체인 값을 찾았습니다.")
            return true
        case errSecItemNotFound:
            return false
        default:
            throw KeychainError.creationError
        }
    }
}
