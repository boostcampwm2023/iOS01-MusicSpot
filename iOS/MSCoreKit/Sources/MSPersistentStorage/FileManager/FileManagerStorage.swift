//
//  UserDefaultsStorage.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

import MSConstants
import MSLogger

public final class FileManagerStorage: NSObject, MSPersistentStorage {
    
    // MARK: - Properties
    
    private let fileManager: FileManager
    
    // MARK: - Initializer
    
    public init(fileManager: FileManager = FileManager()) {
        self.fileManager = fileManager
    }
    
    // MARK: - Functions
    
    public func get<T: Codable>(_ type: T.Type, key: String) -> T? {
        return nil
    }
    
    public func set<T: Codable>(value: T, key: String) {
        
    }
    
    public func deleteAll() throws {
        if let path = self.storageURL()?.path,
           self.fileManager.fileExists(atPath: path) {
            try self.fileManager.removeItem(atPath: path)
        }
    }
    
}

// MARK: - URL

extension FileManagerStorage {
    
    /// Storage가 사용하는 디렉토리 URL을 반환합니다.
    /// - Parameters:
    ///   - create: 디렉토리 URL에 디렉토리가 존재하지 않을 경우 생성할 지 여부를 결정하는 flag
    /// - Returns:
    /// Storage가 사용하는 디렉토리 URL. \
    /// 휙득에 실패했거나, `create` flag가 `true`일 때 생성에 실패했을 경우 `nil`을 반환합니다.
    func storageURL(create: Bool = false) -> URL? {
        let directoryURL: URL?
        if #available(iOS 16.0, *) {
            let storageDirectoryURL = try? self.fileManager.url(for: .applicationDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: .applicationDirectory,
                                                                create: false)
            directoryURL = storageDirectoryURL?
                .appending(path: Constants.appBundleIdentifier, directoryHint: .isDirectory)
        } else {
            let cacheDirectoryURL = self.fileManager
                .urls(for: .applicationDirectory, in: .userDomainMask)
                .first
            directoryURL = cacheDirectoryURL?
                .appendingPathComponent(Constants.appBundleIdentifier, isDirectory: true)
        }
        
        if create {
            switch self.createDirectory(at: directoryURL) {
            case .success(let url):
                return url
            case .failure(let error):
                #if DEBUG
                MSLogger.make(category: .fileManager).log("\(error)")
                #endif
                return nil
            }
        }
        
        return directoryURL
    }
    
    /// 주어진 URL에 디렉토리를 생성합니다.
    /// - Parameters:
    ///   - directoryURL: 디렉토리를 생성할 경로 URL
    /// - Returns:
    /// 디렉토리 생성 여부에 따라 `Result` 타입을 반환합니다. \
    /// 디렉토리 생성에 성공했을 경우 디렉토리 URL을 반환하고, 실패했을 경우 에러를 반환합니다.
    @discardableResult
    func createDirectory(at directoryURL: URL?) -> Result<URL, Error> {
        guard let directoryURL else { return .failure(StorageError.invalidStorageURL) }
        do {
            try self.fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            return .failure(error)
        }
        return .success(directoryURL)
    }
    
    public func fileExists(atPath path: URL, isDirectory: Bool = false) -> Bool {
        var isDirectory: ObjCBool = ObjCBool(isDirectory)
        return self.fileManager.fileExists(atPath: path.absoluteString, isDirectory: &isDirectory)
    }
    
}
