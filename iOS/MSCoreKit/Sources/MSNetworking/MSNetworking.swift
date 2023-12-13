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
        return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
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
    
    public func request<T: Decodable>(_ type: T.Type,
                                      router: Router,
                                      timeoutInterval: TimeoutInterval = .seconds(3)) -> AnyPublisher<T, Error> {
        guard let request = router.request else {
            return Fail(error: MSNetworkError.invalidRouter).eraseToAnyPublisher()
        }
        
        return session
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
    
}
