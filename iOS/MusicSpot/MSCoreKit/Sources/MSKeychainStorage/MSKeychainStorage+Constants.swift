//
//  MSKeychainStorage+Constants.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import MSConstants

extension MSKeychainStorage {
    enum KeychainConstants {
        static let service: String = "\(Constants.appBundleIdentifier).keychainManager"
    }

    public enum Accounts: String, CaseIterable {
        case userID = "MusicSpotUser.v1"
    }
}
