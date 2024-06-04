//
//  CreateSpotRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct CreateSpotRequestDTO {
    // MARK: - Properties

    public let journeyID: String
    public let coordinate: CoordinateDTO
    public let timestamp: Date
    public let photoData: Data

    // MARK: - Initializer

    public init(journeyId: String,
                coordinate: CoordinateDTO,
                timestamp: Date,
                photoData: Data) {
        self.journeyID = journeyId
        self.coordinate = coordinate
        self.timestamp = timestamp
        self.photoData = photoData
    }
}

// MARK: - Encodable

extension CreateSpotRequestDTO: Encodable {
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinate
        case timestamp
    }
}
