//
//  ErrorResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

// MARK: - ErrorResponseDTO

public struct ErrorResponseDTO {
    public let method: String
    public let path: String
    public let timestamp: Date
    public let message: String
    public let statusCode: Int
}

// MARK: Decodable

extension ErrorResponseDTO: Decodable {

    // MARK: Lifecycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        method = try container.decode(String.self, forKey: .method)
        path = try container.decode(String.self, forKey: .path)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        if let message = try? container.decode(String.self, forKey: .message) {
            self.message = message
        } else if
            let decodedMessage = try? container.decode([String].self, forKey: .message),
            let message = decodedMessage.first
        {
            self.message = message
        } else {
            message = ""
        }
        statusCode = try container.decode(Int.self, forKey: .statusCode)
    }

    // MARK: Internal

    enum CodingKeys: String, CodingKey {
        case method
        case path
        case timestamp
        case message
        case statusCode
    }

}
