//
//  MSCacheStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import Foundation

import MSConstants

public final class MSCacheStorage: CacheStorage {
    
    public typealias Key = String
    public typealias Value = Data
    
    public enum CacheResult {
        case success
        case memoryFail
        case diskFail
    }
    
    // MARK: - Properties
    
    private let memory: Cache
    private let disk: FileManager
    
    // MARK: - Initializer
    
    public init(cache: Cache = Cache(),
                fileManager: FileManager = .default) {
        self.memory = cache
        self.disk = fileManager
    }
    
    // MARK: - Functions
    
    /// 캐싱된 데이터를 불러옵니다.
    public func data(forKey key: Key) async -> Value? {
        // Memory Cache
        if let memoryData = self.memory.object(forKey: key as NSString) { // memory hit
            return memoryData as Data
        }
        
        // Disk Cache
        if let cacheURL = self.cacheURL(forCache: key),
           let diskData = self.disk.contents(atPath: cacheURL.path) { // disk hit
            return diskData
        }
        
        return nil
    }
    
    @discardableResult
    public func cache(_ value: Value, forKey key: Key) -> CacheResult {
        // Memory Cache
        self.memory.setObject(value as NSData,
                              forKey: key as NSString,
                              cost: value.count)
        if self.memory.object(forKey: key as NSString) == nil {
            return .memoryFail
        }
        
        // Disk Cache
        guard let cacheURL = self.cacheURL(forCache: key) else {
            return .diskFail
        }
        if #available(iOS 16.0, *) {
            let fileCreated = self.disk.createFile(atPath: cacheURL.path(), contents: value)
            if !fileCreated { return .diskFail }
        } else {
            let fileCreated = self.disk.createFile(atPath: cacheURL.path, contents: value)
            if !fileCreated { return .diskFail }
        }
        
        return .success
    }
    
    @discardableResult
    public func remove(forKey key: Key) -> CacheResult {
        // Memory Cache
        self.memory.removeObject(forKey: key as NSString)
        if self.memory.object(forKey: key as NSString) != nil {
            return .memoryFail
        }
        
        // Disk Cache
        if let cacheURL = self.cacheURL(forCache: key) {
            do {
                try self.disk.removeItem(at: cacheURL)
            } catch {
                return .diskFail
            }
        }
        
        return .success
    }
    
    public func cleanDisk() throws {
        if let path = self.cacheDirectoryURL?.path {
            try self.disk.removeItem(atPath: path)
        }
    }
    
}

// MARK: - URLs

private extension MSCacheStorage {
    
    var cacheDirectoryURL: URL? {
        if #available(iOS 16.0, *) {
            return try? self.disk.url(for: .cachesDirectory,
                                      in: .userDomainMask,
                                      appropriateFor: .cachesDirectory,
                                      create: true)
        } else {
            return self.disk
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first
        }
    }
    
    func cacheURL(forCache cache: String, fileExtension: String = "cache") -> URL? {
        if #available(iOS 16.0, *) {
            return self.cacheDirectoryURL?
                .appending(path: Constants.appName, directoryHint: .isDirectory)
                .appending(component: "\(cache).\(fileExtension)", directoryHint: .notDirectory)
        } else {
            return self.cacheDirectoryURL?
                .appendingPathComponent(Constants.appName, isDirectory: true)
                .appendingPathComponent("\(cache).\(fileExtension)")
        }
    }
    
}
