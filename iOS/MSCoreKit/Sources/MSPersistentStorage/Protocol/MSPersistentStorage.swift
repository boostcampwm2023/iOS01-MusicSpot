//
//  MSPersistentStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

public protocol MSPersistentStorage {
    
    func get<T: Codable>(_ type: T.Type, key: String) -> T?
    func set<T: Codable>(value: T, key: String)
    
}
