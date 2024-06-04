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

    // MARK: - Properties

    private let memory: Cache
    private let disk: FileManager

    // MARK: - Initializer

    public init(cache: Cache = Cache(),
                fileManager: FileManager = .default) {
        self.memory = cache
        self.disk = fileManager
    }

    // MARK: - Read

    /// 캐싱된 데이터를 불러옵니다.
    /// **메모리** 캐시에서 값을 우선적으로 찾은 후, 존재하면 해당 값을 반환합니다.
    /// 그 후에 **디스크** 캐시에서 값을 찾아 존재할 경우 반환합니다.
    /// - Parameters:
    ///   - key: 캐싱된 데이터를 찾기 위한 캐시 Key
    /// - Returns: 캐싱된 데이터를 반환합니다. 데이터가 없을 경우 `nil` 값을 반환합니다.
    public func data(forKey key: Key) -> Value? {
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

    // MARK: - Create

    /// 데이터를 캐싱합니다.
    /// - Parameters:
    ///   - value: 캐싱할 데이터
    ///   - key: 데이터를 캐싱하기 위한 캐시 Key
    /// - Returns:
    /// Result 타입의 캐싱 결과를 반환합니다.
    /// 성공했을 경우 `.success`를,
    /// 메모리 캐싱 중 오류가 발생할 경우 `.memoryFail`을,
    /// 디스크 캐싱 중 오류가 발생할 경우 `.diskFail`을 반환합니다.
    @discardableResult
    public func cache(_ value: Value, forKey key: Key) -> Result<Value, MSCacheError> {
        // Memory Cache
        self.memory.setObject(value as NSData,
                              forKey: key as NSString,
                              cost: value.count)
        if self.memory.object(forKey: key as NSString) == nil {
            return .failure(.memoryFail)
        }

        // Disk Cache
        guard let cacheURL = self.cacheURL(forCache: key) else {
            return .failure(.diskFail)
        }
        let cacheURLString: String
        if #available(iOS 16.0, *) {
            cacheURLString = cacheURL.path()
        } else {
            cacheURLString = cacheURL.path
        }
        if self.disk.createFile(atPath: cacheURLString, contents: value) == false {
            return .failure(.diskFail)
        }

        return .success(value)
    }

    // MARK: - Delete

    /// 캐싱된 데이터를 제거합니다.
    /// - Parameters:
    ///   - key: 제거할 캐시를 찾기 위한 캐시 Key
    /// - Throws:
    /// 메모리 캐싱 중 오류가 발생할 경우 `.memoryFail` 에러,
    /// 디스크 캐싱 중 오류가 발생할 경우 `.diskFail` 에러를 throw 합니다.
    public func remove(forKey key: Key) throws {
        // Memory Cache
        self.memory.removeObject(forKey: key as NSString)
        if self.memory.object(forKey: key as NSString) != nil {
            throw MSCacheError.memoryFail
        }

        // Disk Cache
        guard let cacheURL = self.cacheURL(forCache: key) else {
            throw MSCacheError.diskFail
        }
        do {
            try self.disk.removeItem(at: cacheURL)
        } catch {
            throw MSCacheError.diskFail
        }
    }

    // MARK: - Clean

    /// 캐싱된 데이터를 삭제합니다.
    /// - Parameters:
    ///   - target: 삭제할 대상을 선택합니다.
    ///     - `.all`: **디스크와 메모리** 캐시를 모두 삭제합니다.
    ///     - `.disk`: **디스크**에 저장된 캐시를 모두 삭제합니다.
    ///     - `.memory`: **메모리**에 저장된 캐시를 모두 삭제합니다.
    public func clean(_ target: CacheStorageTarget) throws {
        switch target {
        case .all:
            try self.cleanAll()
        case .memory:
            self.cleanMemory()
        case .disk:
            try self.cleanDisk()
        }
    }

    private func cleanAll() throws {
        self.cleanMemory()
        try self.cleanDisk()
    }

    private func cleanMemory() {
        self.memory.removeAllObjects()
    }

    private func cleanDisk() throws {
        if let path = self.cacheDirectoryURL?.path {
            try self.disk.removeItem(atPath: path)
        }
    }
}

// MARK: - URLs

private extension MSCacheStorage {
    var cacheDirectoryURL: URL? {
        let directoryURL: URL?

        if #available(iOS 16.0, *) {
            let cacheDirectoryURL = try? self.disk.url(for: .cachesDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: .cachesDirectory,
                                                       create: false)
            directoryURL = cacheDirectoryURL?
                .appending(path: Constants.appBundleIdentifier, directoryHint: .isDirectory)
        } else {
            let cacheDirectoryURL = self.disk
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first
            directoryURL = cacheDirectoryURL?
                .appendingPathComponent(Constants.appBundleIdentifier, isDirectory: true)
        }

        guard let directoryURL else { return nil }
        do {
            try self.disk.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            return nil
        }

        return directoryURL
    }

    func cacheURL(forCache cache: String, fileExtension: String = "cache") -> URL? {
        if #available(iOS 16.0, *) {
            return self.cacheDirectoryURL?
                .appending(component: cache, directoryHint: .notDirectory)
                .appendingPathExtension(fileExtension)
        } else {
            return self.cacheDirectoryURL?
                .appendingPathComponent(cache)
                .appendingPathExtension(fileExtension)
        }
    }
}
