//
//  CacheStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.11.28.
//

import Foundation

public protocol CacheStorage {
    
    associatedtype Key: AnyObject = NSString
    associatedtype Value: AnyObject
    
    typealias Cache = NSCache<Key, Value>
    
    // MARK: - Functions
    
    func data(forKey key: Key) async -> Value?
    func cleanDisk() throws
    
}
