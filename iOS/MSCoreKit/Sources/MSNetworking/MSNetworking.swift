//
//  MSNetworking.swift
//  MSCoreKit
//
//  Created by 전민건 on 11/16/23.
//

import Foundation
import Combine

public struct MSNetworking {
    
    // MARK: - Properties
    
    private let encoder = JSONEncoder()
    private let session: Session
    
    // MARK: - Initializer
    
    public init(session: Session) {
        self.session = session
    }
    
    // MARK: - Functions
    
    public func request<T: Decodable>(router: Router, type: T.Type) -> AnyPublisher<T, Error>? {
        guard let request: URLRequest = router.asURLRequest() else {
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
