//
//  UserResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct UserResponseDTO {
    // MARK: - Properties

    public let userID: UUID

    // MARK: - Initializer

}

extension UserResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
