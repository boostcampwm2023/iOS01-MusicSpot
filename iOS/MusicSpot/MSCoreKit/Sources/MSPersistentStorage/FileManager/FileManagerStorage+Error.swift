//
//  FileManagerStorage+Error.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

extension FileManagerStorage {
    public enum StorageError: Error {
        case invalidStorageURL
    }
}
