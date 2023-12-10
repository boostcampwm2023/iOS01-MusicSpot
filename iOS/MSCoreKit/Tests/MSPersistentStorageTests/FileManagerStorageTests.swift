//
//  MSPersistentStorageTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import OSLog
import XCTest
@testable import MSPersistentStorage

final class MSPersistentStorageTests: XCTestCase {
    
    // MARK: - Properties
    
    private let fileStorage = FileManagerStorage()
    
    // MARK: - Setup
    
    // MARK: - Test
    
    func test_StorageURL생성출력_항상성공() {
        guard let storageURL = self.fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        os_log("\(storageURL)")
    }
    
    func test_FileURL생성출력_항상성공() {
        let key = UUID().uuidString
        guard let fileURL = self.fileStorage.fileURL(forKey: key) else {
            XCTFail("파일 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        os_log("\(fileURL)")
    }
    
    func test_StorageURL디렉토리_생성_성공() {
        guard let url = self.fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        
        let result = self.fileStorage.createDirectory(at: url)
        switch result {
        case .success(let url):
            let parentURL = url
            let fileExists = self.fileStorage.fileExists(atPath: parentURL, isDirectory: true)
            XCTAssertFalse(fileExists, "디렉토리 생성에 실패했습니다: \(parentURL)")
        case .failure(let error):
            XCTFail("디렉토리 생성에 실패했습니다: \(error)")
        }
    }
    
    func test_StorageURL디렉토리_전체삭제_성공() throws {
        guard let url = self.fileStorage.storageURL() else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        self.fileStorage.createDirectory(at: url)
        
        try self.fileStorage.deleteAll()
        
        let fileExists = self.fileStorage.fileExists(atPath: url, isDirectory: true)
        XCTAssertFalse(fileExists, "디렉토리 전체 삭제 후에는 디렉토리가 존재하면 안됩니다.")
    }
    
    func test_StorageURL에_디렉토리가없을경우_생성_성공() throws {
        try self.fileStorage.deleteAll()
        
        guard let storageURL = self.fileStorage.storageURL(create: true) else {
            XCTFail("FileManagerStorage 디렉토리 URL 휙득에 실패했습니다.")
            return
        }
        
        let fileExists = self.fileStorage.fileExists(atPath: storageURL, isDirectory: true)
        XCTAssertFalse(fileExists, "storageURL(create: true)는 디렉토리가 존재하지 않을 경우 새로 생성해야 합니다.")
    }
    
    func test_FileManagerStorage에_데이터저장_성공() {
        let sut = MockCodableData(title: "boostcamp", content: "wm8")
        let key = "S045"
        
        let storedData = self.fileStorage.set(value: sut, forKey: key)
        XCTAssertNotNil(storedData, "데이터가 저장되지 않았습니다.")
    }
    
    func test_FileManagerStorage에서_데이터로드_성공() {
        let sut = MockCodableData(title: "boostcamp", content: "wm8")
        let key = "S045"
        self.fileStorage.set(value: sut, forKey: key)
        
        guard let storedData = self.fileStorage.get(MockCodableData.self, forKey: key) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }
        
        XCTAssertEqual(sut, storedData,
                       "목표 데이터와 불러온 값이 다릅니다.")
    }
    
    func test_FileManagerStorage에서_모든데이터저장불러오기_성공() {
        let sut = MockCodableData(title: "boostcamp", content: "wm8")
        let key = "S045"
        self.fileStorage.set(value: sut, forKey: key)
        self.fileStorage.set(value: sut, forKey: key)
        self.fileStorage.set(value: sut, forKey: key)
        
        guard let allStoredData = self.fileStorage.getAllOf(MockCodableData.self) else {
            XCTFail("데이터 읽기에 실패했습니다.")
            return
        }
        
        allStoredData.forEach { storedData in
            XCTAssertEqual(sut, storedData,
                           "목표 데이터와 불러온 값이 다릅니다.")
        }
    }
    
}
