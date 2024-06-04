//
//  UserRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.06.
//

import Foundation

public struct UserRequestDTO {
    // MARK: - Properties

    public let userID: UUID

    // MARK: - Initializer

    public init(userID: UUID) {
        self.userID = userID
    }
}

// MARK: - Encodable

extension UserRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
