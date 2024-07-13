//
//  MSKeychainStorage+Constants.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.06.
//

import MSConstants

extension MSKeychainStorage {

    // MARK: Public

    public enum Accounts: String, CaseIterable {
        case userID = "MusicSpotUser.v1"
    }

    // MARK: Internal

    enum KeychainConstants {
        static let service = "\(Constants.appBundleIdentifier).keychainManager"
    }

}
