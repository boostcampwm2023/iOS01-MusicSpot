//
//  AppStoreLookUp.swift
//  VersionManager
//
//  Created by 이창준 on 2024.02.19.
//

import Foundation

// MARK: - AppStoreResponse

public struct AppStoreResponse: Decodable {
    let numberOfResults: Int?
    let results: [AppStoreLookUp]

    enum CodingKeys: String, CodingKey {
        case numberOfResults = "resultCount"
        case results
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        numberOfResults = try container.decodeIfPresent(Int.self, forKey: .numberOfResults)
        results = try container.decodeIfPresent([AppStoreLookUp].self, forKey: .results) ?? []
    }
}

// MARK: - AppStoreLookUp

public struct AppStoreLookUp: Decodable {
    let releaseNote: String?
    let releaseDate: Date?
    let version: String?
}
