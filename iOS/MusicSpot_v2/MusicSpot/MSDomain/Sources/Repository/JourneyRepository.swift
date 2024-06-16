//
//  JourneyRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import SwiftData

import Entity
import MSError

public protocol JourneyRepository {
    func fetchJourneys(in region: Region) async throws -> [Journey]
    func fetchTravelingJourney() async throws(JourneyError) -> Journey
    @discardableResult
    func updateJourney(_ journey: Journey) async throws(JourneyError) -> Journey
    @discardableResult
    func endJourney(_ journey: Journey, isCancelled: Bool) async throws(JourneyError) -> Journey
    @discardableResult
    // TODO: SwiftLint Swift 6 적용 후 삭제
    // swiftlint:disable:next identifier_name
    func deleteJourney(_ journey: Journey) async throws(JourneyError) -> Journey
}

extension JourneyRepository {
    @discardableResult
    public func endJourney(_ journey: Journey, isCancelled: Bool = false) async throws(JourneyError) -> Journey {
        return try await self.endJourney(journey, isCancelled: isCancelled)
    }
}
