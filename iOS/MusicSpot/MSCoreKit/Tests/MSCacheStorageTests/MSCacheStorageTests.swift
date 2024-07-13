//
//  MSCacheStorageTests.swift
//  MSCoreKit
//
//  Created by 이창준 on 11/14/23.
//

import XCTest

@testable import MSCacheStorage

final class MSCacheStorageTests: XCTestCase {

    // MARK: Internal

    // MARK: - Setup

    override func setUp() async throws {
        let memory = CacheStorage.Cache()
        let disk = FileManager.default
        cacheStorage = MSCacheStorage(cache: memory, fileManager: disk)
    }

    override func tearDown() async throws {
        try cacheStorage.clean(.all)
        cacheStorage = nil
    }

    // MARK: - Tests

    func test_새로운Key값으로_캐싱_성공() {
        let sut = Data(mockData.utf8)

        let result = cacheStorage.cache(sut, forKey: key)
        XCTAssertEqual(
            result,
            .success(sut),
            "새로운 Key 값으로 저장한 값은 .success 결과를 반환해야 합니다.")
    }

    func test_중복된Key값으로_캐싱_성공() {
        let sut = Data(mockData.utf8)
        let sut2 = Data("AnoterTest".utf8)

        cacheStorage.cache(sut, forKey: key)
        let result = cacheStorage.cache(sut2, forKey: key)
        XCTAssertEqual(
            result,
            .success(sut2),
            "중복된 Key 값으로 저장할 경우, 이전 캐싱된 값을 대체하며 성공해야 합니다.")
    }

    func test_존재하는Key값으로_캐시데이터조회_데이터반환_성공() throws {
        let sut = Data(mockData.utf8)

        let result = cacheStorage.cache(sut, forKey: key)
        guard let cachedValue = cacheStorage.data(forKey: key) else {
            XCTFail("캐싱된 데이터로부터 nil 값이 반환 되었습니다.")
            return
        }

        let decodedData = String(data: cachedValue, encoding: .utf8)
        XCTAssertEqual(
            decodedData,
            mockData,
            "캐싱한 값과 불러온 값이 일치하지 않습니다.")
    }

    func test_존재하지않는Key값으로_캐시데이터조회_nil반환_성공() {
        let sut = Data(mockData.utf8)

        cacheStorage.cache(sut, forKey: key)
        let nilValue = cacheStorage.data(forKey: "undefined key")

        XCTAssertNil(nilValue, "존재하지 않는 key 값은 nil 값을 반환해야 합니다.")
    }

    // MARK: Private

    // MARK: - Properties

    private var cacheStorage: MSCacheStorage!
    private var mockData = "TESTVALUE"
    private let key = "cacheKey"

}
