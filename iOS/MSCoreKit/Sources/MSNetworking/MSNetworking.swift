//
//  MSNetworking.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation
import Combine

public struct MSNetworking {
    
    public typealias TimeoutInterval = DispatchQueue.SchedulerTimeType.Stride
    
    // MARK: - Constants
    
    public static let dispatchQueueLabel = "com.MSNetworking.MSCoreKit.MusicSpot"
    
    // MARK: - Properties
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        encoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            let dateString = dateFormatter.string(from: date)
            try container.encode(dateString)
        }
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
                print(dateString)
                return date
            }
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Date 디코딩 실패: \(dateString)")
        })
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let session: Session
    public let queue: DispatchQueue
    
    // MARK: - Initializer
    
    public init(session: Session) {
        self.session = session
        self.queue = DispatchQueue(label: MSNetworking.dispatchQueueLabel, qos: .background)
    }
    
    // MARK: - Functions
    
    /// ``Router``를 사용해 HTTP 네트워킹을 수행합니다. Combine을 사용합니다.
    /// - Parameters:
    ///   - type: 결과로 받을 값의 타입. `String.self`의 형태로 제공합니다.
    ///   - router: 네트워킹에 대한 정보를 담은 ``Router``
    ///   - timeoutInterval: 네트워킹에 대한 타임아웃 시간
    /// - Returns: 결과값과 에러를 담은 AnyPublisher
    public func request<T: Decodable>(_ type: T.Type,
                                      router: Router,
                                      timeoutInterval: TimeoutInterval = .seconds(3)) -> AnyPublisher<T, Error> {
        guard let request = router.makeRequest(encoder: self.encoder) else {
            return Fail(error: MSNetworkError.invalidRouter).eraseToAnyPublisher()
        }
        
        return self.session
            .dataTaskPublisher(for: request)
            .timeout(timeoutInterval, scheduler: self.queue)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse else {
                    throw MSNetworkError.unknownResponse
                }
                guard 200..<300 ~= response.statusCode else {
                    throw MSNetworkError.invalidStatusCode(statusCode: response.statusCode,
                                                           description: response.description)
                }
                return data
            }
            .decode(type: T.self, decoder: self.decoder)
            .eraseToAnyPublisher()
    }
    
    /// ``Router``를 사용해 HTTP 네트워킹을 수행합니다. Swift Concurrency을 사용합니다.
    /// - Parameters:
    ///   - type: 결과로 받을 값의 타입. `String.self`의 형태로 제공합니다.
    ///   - router: 네트워킹에 대한 정보를 담은 ``Router``
    ///   - timeoutInterval: 네트워킹에 대한 타임아웃 시간
    /// - Returns: 결과값과 에러를 담은 Result
    public func request<T: Decodable>(_ type: T.Type,
                                      router: Router,
                                      timeoutInterval: TimeoutInterval = .seconds(3)) async -> Result<T, Error> {
        guard let request = router.makeRequest(encoder: self.encoder) else {
            return .failure(MSNetworkError.invalidRouter)
        }
        
        let dataTask = Task {
            try await self.session.data(for: request, delegate: nil)
        }
        
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: UInt64(timeoutInterval.magnitude) * 1_000_000_000)
            dataTask.cancel()
        }
        
        do {
            return try await withTaskCancellationHandler {
                let (data, response) = try await dataTask.value
                timeoutTask.cancel()
                
                guard let response = response as? HTTPURLResponse else {
                    return .failure(MSNetworkError.unknownResponse)
                }
                guard 200..<300 ~= response.statusCode else {
                    let errorResponse = try self.decoder.decode(ErrorResponseDTO.self, from: data)
                    throw MSNetworkError.invalidStatusCode(statusCode: errorResponse.statusCode,
                                                           description: errorResponse.message)
                }
                
                let result = try self.decoder.decode(T.self, from: data)
                return .success(result)
            } onCancel: {
                dataTask.cancel()
                timeoutTask.cancel()
            }
        } catch {
            return .failure(error)
        }
    }
    
}
