//
//  JourneyMetadataDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

public struct JourneyMetadataDTO {
    public let startTimestamp: Date
    public let endTimestamp: Date
}

// MARK: - Codable

extension JourneyMetadataDTO: Codable {
    enum CodingKeys: String, CodingKey {
        case startTimestamp
        case endTimestamp
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startTimestamp = try container.decode(Date.self, forKey: .startTimestamp)
        if let endTimestamp = try? container.decode(String.self, forKey: .endTimestamp),
           endTimestamp.isEmpty {
            self.endTimestamp = .now
            return
        }
        self.endTimestamp = try container.decode(Date.self, forKey: .endTimestamp)
    }
}
