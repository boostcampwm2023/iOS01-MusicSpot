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
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFractionalSeconds, .withTimeZone, .withInternetDateTime]
        encoder.dateEncodingStrategy = .custom({ date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = dateFormatter.string(from: date)
            try container.encode(dateString)
        })
        return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Date 디코딩 실패: \(dateString)")
        })
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    // MARK: - Initializer
    
    public init(fileManager: FileManager = FileManager()) {
        self.fileManager = fileManager
    }
    
    // MARK: - Functions
    
    /// `FileManager`를 사용한 PersistentStorage에서 Key 값에 해당되는 값을 불러옵니다.
    /// - Parameters:
    ///   - type: 불러올 값의 타입
    ///   - key: 불러올 값에 대응되는 Key 값
    /// - Returns: `FileManager`에서 불러온 뒤 지정된 타입으로 디코딩 된 값
    public func get<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let fileURL = self.fileURL(forKey: key),
              let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        guard let decodedData = try? self.decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return decodedData
    }
    
    public func getAllOf<T: Codable>(_ type: T.Type) -> [T]? {
        if let path = self.storageURL()?.path,
           let contents = try? self.fileManager.contentsOfDirectory(atPath: path) {
            let allDecodedData: [T] = contents.compactMap { content in
                let key = String(content.dropLast(".json".count))
                guard let dataPath =
                        fileURL(forKey: key) else {
                    MSLogger.make(category: .fileManager).error("경로의 Data를 가져오지 못하였습니다.")
                    return nil
                }
                MSLogger.make(category: .fileManager).error("경로의 Data를 성공적으로 가져왔습니다.")
                
                guard let data = try? Data(contentsOf: dataPath),
                      let decodedData = try? self.decoder.decode(T.self, from: data) else {
                    MSLogger.make(category: .fileManager).error("decode에 실패하였습니다.")
                    return nil
                }
                return decodedData
            }
            return allDecodedData
        }
        return nil
    }
    
    /// `FileManager`를 사용한 PersistentStorage에 주어진 Key 값으로 주어진 데이터 `value`를 저장합니다.
    /// - Parameters:
    ///   - value: 저장할 데이터
    ///   - key: 저장할 값에 대응되는 Key 값
    /// - Returns:
    /// `FileManager`를 사용한 저장에 성공했을 경우 요청한 데이터를 반환합니다. \
    /// 저장에 실패했거나 이미 존재한다면 `nil`을 반환합니다.
    @discardableResult
    public func set<T: Codable>(value: T, forKey key: String) -> T? {
        guard let fileURL = self.fileURL(forKey: key) else {
            return nil
        }
        
        guard let encodedData = try? self.encoder.encode(value) else {
            return nil
        }
        
        do {
            try encodedData.write(to: fileURL)
            return value
        } catch {
            #if DEBUG
            MSLogger.make(category: .fileManager).error("인코딩 데이터를 저장하는데 실패했습니다: \(fileURL.absoluteString)")
            #endif
            return nil
        }
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
    
    /// 지정된 Key 값을 사용해 접근할 파일의 URL을 반환합니다.
    /// - Parameters:
    ///   - key: 접근할 파일의 Key 값
    /// - Returns:
    /// 지정된 Key 값에 대응되는 파일의 URL. \
    /// 휙득에 실패했을 경우 `nil`을 반환합니다.
    func fileURL(forKey key: String) -> URL? {
        let fileURL: URL?
        if #available(iOS 16.0, *) {
            fileURL = self.storageURL(create: true)?
                .appending(component: key, directoryHint: .notDirectory)
                .appendingPathExtension("json")
        } else {
            fileURL = self.storageURL(create: true)?
                .appendingPathComponent(key, isDirectory: false)
                .appendingPathExtension("json")
        }
        return fileURL
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
