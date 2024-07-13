//
//  MSImageFetcher.swift
//  MSCoreKit
//
//  Created by 이창준 on 2023.12.02.
//

import Foundation

import MSCacheStorage
import MSLogger

public final class MSImageFetcher {

    // MARK: Lifecycle

    private init(
        cache: MSCacheStorage = MSCacheStorage(),
        session: URLSession = URLSession(configuration: .default))
    {
        self.cache = cache
        self.session = session
    }

    // MARK: Public

    // MARK: - Singleton

    public static let shared = MSImageFetcher()

    // MARK: - Functions

    /// - Parameters:
    ///   - photoURL: 가져올 사진의 URL
    ///   - key: 사진의 캐싱을 처리하기 위한 key 값
    @discardableResult
    public func fetchImage(
        from photoURL: URL,
        forKey key: String)
        async -> Data?
    {
        // 1. 캐싱된 값이 있는 지 확인합니다.
        // 2. 있다면 캐싱된 이미지를 반환합니다.
        if let imageData = cache.data(forKey: key) {
            #if DEBUG
            MSLogger.make(category: .imageFetcher)
                .log("이미지 데이터를 캐시로부터 불러왔습니다: \(imageData)")
            #endif
            return imageData
        }
        // 3. 없다면 네트워크 요청을 합니다.
        // 4. 네트워크에서 받아온 이미지를 반환합니다.
        var request = URLRequest(url: photoURL)
        request.httpMethod = "GET"
        if let (data, _) = try? await session.data(for: request) {
            #if DEBUG
            MSLogger.make(category: .imageFetcher)
                .log("이미지 데이터를 네트워크로부터 불러왔습니다: \(data)")
            #endif

            // 5. 이미지 데이터를 캐싱합니다.
            cache.cache(data, forKey: key)

            return data
        }

        return nil
    }

    // MARK: Internal

    typealias CacheTask = Task<Data?, Error>

    // MARK: Private

    // MARK: - Properties

    private let cache: MSCacheStorage
    private let session: URLSession

    private var cacheStorage: Set<UUID> = []

}
