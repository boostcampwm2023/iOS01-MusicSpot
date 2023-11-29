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
    /// **메모리** 캐시에서 값을 우선적으로 찾은 후, 존재하면 해당 값을 반환합니다.
    /// 그 후에 **디스크** 캐시에서 값을 찾아 존재할 경우 반환합니다.
    /// - Parameters:
    ///   - key: 캐싱된 데이터를 찾기 위한 캐시 Key
    /// - Returns: 캐싱된 데이터를 반환합니다. 데이터가 없을 경우 `nil` 값을 반환합니다.
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
    
    /// 데이터를 캐싱합니다.
    /// - Parameters:
    ///   - value: 캐싱할 데이터
    ///   - key: 데이터를 캐싱하기 위한 캐시 Key
    /// - Returns:
    /// 캐싱 결과를 반환합니다.
    /// 성공했을 경우 `.success`를,
    /// 메모리 캐싱 중 오류가 발생할 경우 `.memoryFail`을,
    /// 디스크 캐싱 중 오류가 발생할 경우 `.diskFail`을 반환합니다.
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
        let cacheURLString: String
        if #available(iOS 16.0, *) {
            cacheURLString = cacheURL.path()
        } else {
            cacheURLString = cacheURL.path
        }
        if self.disk.createFile(atPath: cacheURLString, contents: value) == false {
            return .diskFail
        }
        
        return .success
    }
    
    /// 캐싱된 데이터를 제거합니다.
    /// - Parameters:
    ///   - key: 제거할 캐시를 찾기 위한 캐시 Key
    /// - Returns:
    /// 캐시 값을 제거한 결과를 반환합니다.
    /// 성공했을 경우 `.success`를,
    /// 메모리 캐싱 중 오류가 발생할 경우 `.memoryFail`을,
    /// 디스크 캐싱 중 오류가 발생할 경우 `.diskFail`을 반환합니다.
    @discardableResult
    public func remove(forKey key: Key) -> CacheResult {
        // Memory Cache
        self.memory.removeObject(forKey: key as NSString)
        if self.memory.object(forKey: key as NSString) != nil {
            return .memoryFail
        }
        
        // Disk Cache
        guard let cacheURL = self.cacheURL(forCache: key) else {
            return .diskFail
        }
        do {
            try self.disk.removeItem(at: cacheURL)
        } catch {
            return .diskFail
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
