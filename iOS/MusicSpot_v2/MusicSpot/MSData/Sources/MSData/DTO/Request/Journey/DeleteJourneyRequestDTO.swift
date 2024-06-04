//
//  DeleteJourneyRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

public struct DeleteJourneyRequestDTO: Encodable {
    // MARK: - Properties

    public let userID: UUID
    public let journeyID: String

    // MARK: - Encodable

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case journeyID = "journeyId"
    }
}
