//
//  MSPersistentStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

public protocol MSPersistentStorage {
    
    func get<T: Codable>(_ type: T.Type, forKey key: String, subpath: String?) -> T?
    @discardableResult
    func set<T: Codable>(value: T, forKey key: String, subpath: String?) -> T?
    func delete(forKey key: String, subpath: String?) throws
    func deleteAll(subpath: String?) throws

}

extension MSPersistentStorage {
    
    public func get<T: Codable>(_ type: T.Type, forKey key: String, subpath: String? = nil) -> T? {
        return self.get(type, forKey: key, subpath: nil)
    }
    
    @discardableResult
    public func set<T: Codable>(value: T, forKey key: String, subpath: String? = nil) -> T? {
        return self.set(value: value, forKey: key, subpath: subpath)
    }
    
    public func delete(forKey key: String, subpath: String? = nil) throws {
        try self.delete(forKey: key, subpath: subpath)
    }
    
    public func deleteAll(subpath: String? = nil) throws {
        try self.deleteAll(subpath: subpath)
    }
    
}
