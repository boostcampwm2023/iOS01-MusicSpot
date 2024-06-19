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
    // MARK: - Properties

    private let context: ModelContext

    // MARK: - Initializer

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        let predicate = #Predicate<JourneyLocalDataSource> { journey in
            return consume region.containsAny(of: journey.coordinates)
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)
        let result = try self.context.fetch(consume descriptor)
        return result.map { $0.toEntity() }
    }

    public func fetchTravelingJourney() async throws(JourneyError) -> Journey {
        let predicate = #Predicate<JourneyLocalDataSource> { journey in
            return journey.isTraveling
        }
        let descriptor = FetchDescriptor(predicate: consume predicate)
        guard let results = try? self.context.fetch(consume descriptor),
              results.count == 1 else {
            throw .multipleTravelingJourneys
        }

        guard let result = results.first else {
            throw .multipleTravelingJourneys
        }

        return result.toEntity()
    }

    @discardableResult
    public func updateJourney(_ journey: Journey) async throws(JourneyError) -> Journey {
        .sample
    }

    @discardableResult
    public func endJourney(_ journey: Journey, isCancelled: Bool) async throws(JourneyError) -> Journey {
        .sample
    }

    @discardableResult
    // TODO: SwiftLint Swift 6 적용 후 삭제
    // swiftlint:disable:next identifier_name
    public func deleteJourney(_ journey: Journey) async throws(JourneyError) -> Journey {
        .sample
    }
}
