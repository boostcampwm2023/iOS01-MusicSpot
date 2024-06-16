//
//  AppJourneyRepository.swift
//  AppRepository
//
//  Created by 이창준 on 6/4/24.
//

import Foundation
import SwiftData

import DataSource
import Entity
import MSError
import Repository

public final class AppJourneyRepository: JourneyRepository {
    private var context: ModelContext!

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        []
    }

    public func fetchTravelingJourney() async throws -> Journey {
        return .sample
    }

    public func saveJourney(_ journey: Journey) async throws(JourneyError) -> Journey {
        return .sample
    }
}
