//
//  StartJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct StartJourneyResponseDTO {
    // MARK: - Properties

    public let coordinate: CoordinateDTO
    public let startTimestamp: Date
    /// 시작된 여정에 대한 ID 값
    public let journeyID: String

    // MARK: - Initializer

    public init(coordinate: CoordinateDTO,
                startTimestamp: Date,
                journeyID: String) {
        self.coordinate = coordinate
        self.startTimestamp = startTimestamp
        self.journeyID = journeyID
    }
}

// MARK: - Decodable

extension StartJourneyResponseDTO: Decodable {
    enum CodingKeys: String, CodingKey {
        case coordinate
        case startTimestamp
        case journeyID = "journeyId"
    }
}
