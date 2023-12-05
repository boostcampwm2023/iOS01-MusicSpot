//
//  UserRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct UserRequestDTO: Encodable {
    
    public let userID: UUID
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
    
}
