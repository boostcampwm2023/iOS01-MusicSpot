//
//  ErrorResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct ErrorResponseDTO: Decodable {
    
    public let method: String
    public let path: String
    public let timestamp: Date
    public let message: String
    public let statusCode: Int
    
}
