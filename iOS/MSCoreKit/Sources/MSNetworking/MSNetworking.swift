//
//  MSNetworking.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//
import Foundation
import Combine

struct MSNetworking {
    
    private let session: Session
    
    func request<T: Decodable>(requestable: Requestable, type: T.Type) -> AnyPublisher<T, Error>? {
        
        guard let request: URLRequest = requestable.asURLRequest() else {
            return nil
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap { result -> T in
                let value = try JSONDecoder().decode(T.self, from: result.data)
                guard let response = result.response as? HTTPURLResponse else {
                    throw MSNetworkError.noResponse
                }
                guard (200...299).contains(response.statusCode) else {
                    throw MSNetworkError.responseCode
                }
                return value
            }
            .eraseToAnyPublisher()
    }
}
