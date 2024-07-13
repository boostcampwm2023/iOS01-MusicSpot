//
//  ErrorResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct ErrorResponseDTO {
    public let method: String
    public let path: String
    public let timestamp: Date
    public let message: String
    public let statusCode: Int
}

extension ErrorResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case method
        case path
        case timestamp
        case message
        case statusCode
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.method = try container.decode(String.self, forKey: .method)
        self.path = try container.decode(String.self, forKey: .path)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        if let message = try? container.decode(String.self, forKey: .message) {
            self.message = message
        } else if let decodedMessage = try? container.decode([String].self, forKey: .message),
                  let message = decodedMessage.first {
            self.message = message
        } else {
            self.message = ""
        }
        self.statusCode = try container.decode(Int.self, forKey: .statusCode)
    }
}
