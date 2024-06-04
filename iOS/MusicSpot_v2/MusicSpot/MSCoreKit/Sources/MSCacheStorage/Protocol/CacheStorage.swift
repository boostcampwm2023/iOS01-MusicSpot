//
//  CacheStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.11.28.
//

import Foundation

public protocol CacheStorage {
    associatedtype Key = String
    associatedtype Value
    typealias Cache = NSCache<NSString, NSData>

    // MARK: - Functions

    func data(forKey key: Key) -> Value?
    func cache(_ value: Value, forKey key: Key) -> Result<Value, MSCacheError>
    func remove(forKey key: Key) throws

    func clean(_ target: CacheStorageTarget) throws
}

public enum CacheStorageTarget {
    case all
    case memory
    case disk
}
