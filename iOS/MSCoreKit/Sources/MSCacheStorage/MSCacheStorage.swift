//
//  MSCacheStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import Foundation

import MSUserDefaults

public protocol KeyValueStorage {
    associatedtype Value
    func data(forKey key: String, etag: String?) async -> Value?
    func cleanDisk() throws
}

public final class MSCacheStorage: KeyValueStorage {
    
    public typealias Key = NSString
    public typealias Cache = NSCache<Key, MSCacheableData>
    
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
    public func data(forKey key: String, etag: String? = nil) async -> MSCacheableData? {
        // Memory Cache
        if let memoryData = memory.object(forKey: key as NSString) { // memory hit
            // TODO: 서버와 데이터 검증 필요 (etag 활용)
            return memoryData
        }
        
        // Disk Cache
        if let cacheURL = cacheURL(forCache: "\(key).cache"),
           let diskData = disk.contents(atPath: cacheURL.path) { // disk hit
            // TODO: 서버와 데이터 검증 필요 (etag 활용)
            let decoder = JSONDecoder()
            return try? decoder.decode(MSCacheableData.self, from: diskData)
        }
        
        // Request
        // TODO: 서버로부터 데이터 수신 및 캐싱 + return 값 변경
        return nil
    }
    
    public func cleanDisk() throws {
        if let path = cacheDirectoryURL?.path {
            try disk.removeItem(atPath: path)
        }
    }
    
}

// MARK: - URLs

private extension MSCacheStorage {
    
    var cacheDirectoryURL: URL? {
        if #available(iOS 16.0, *) {
            return try? disk.url(for: .cachesDirectory,
                                 in: .userDomainMask,
                                 appropriateFor: .cachesDirectory,
                                 create: true)
        } else {
            return disk
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first
        }
    }
    
    func cacheURL(forCache cache: String) -> URL? {
        if #available(iOS 16.0, *) {
            return cacheDirectoryURL?
                .appending(path: "MusicSpot", directoryHint: .isDirectory)
                .appending(component: cache, directoryHint: .notDirectory)
        } else {
            return cacheDirectoryURL?
                .appendingPathExtension("MusicSpot")
                .appendingPathComponent(cache)
        }
    }
    
}
