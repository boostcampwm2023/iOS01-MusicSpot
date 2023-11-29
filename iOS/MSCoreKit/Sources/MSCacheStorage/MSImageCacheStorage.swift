//
//  MSImageCacheStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import Foundation

public final class MSImageCacheStorage: CacheStorage {
    
    public typealias Cache = NSCache<NSString, NSData>
    
    // MARK: - Properties
    
    private let memory: Cache
    private let disk: FileManager
    
    private let decoder = JSONDecoder()
    
    // MARK: - Initializer
    
    public init(cache: Cache = Cache(),
                fileManager: FileManager = .default) {
        self.memory = cache
        self.disk = fileManager
    }
    
    // MARK: - Functions
    
    /// 캐싱된 데이터를 불러옵니다.
    public func data(forKey key: NSString) async -> NSData? {
        // Memory Cache
        if let memoryData = self.memory.object(forKey: key as NSString) { // memory hit
            return memoryData
        }
        
        // Disk Cache
        if let cacheURL = self.cacheURL(forCache: "\(key).cache"),
           let diskData = self.disk.contents(atPath: cacheURL.path) { // disk hit
            return NSData(data: diskData)
        }
        
        return nil
    }
    
    public func cleanDisk() throws {
        if let path = self.cacheDirectoryURL?.path {
            try self.disk.removeItem(atPath: path)
        }
    }
    
}

// MARK: - URLs

private extension MSImageCacheStorage {
    
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
    
    func cacheURL(forCache cache: String) -> URL? {
        if #available(iOS 16.0, *) {
            return self.cacheDirectoryURL?
                .appending(path: "MusicSpot", directoryHint: .isDirectory)
                .appending(component: cache, directoryHint: .notDirectory)
        } else {
            return self.cacheDirectoryURL?
                .appendingPathExtension("MusicSpot")
                .appendingPathComponent(cache)
        }
    }
    
}
