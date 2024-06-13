//
//  JourneyRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import SwiftData

import Entity

public protocol JourneyRepository {
    func fetchJourneys(in region: Region) async throws -> [Journey]
}
