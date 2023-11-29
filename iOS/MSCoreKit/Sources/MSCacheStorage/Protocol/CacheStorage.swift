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
    
    associatedtype CacheResult
    
    // MARK: - Functions
    
    func data(forKey key: Key) async -> Value?
    func cache(_ value: Value, forKey key: Key) -> CacheResult
    func cleanDisk() throws
    
}
