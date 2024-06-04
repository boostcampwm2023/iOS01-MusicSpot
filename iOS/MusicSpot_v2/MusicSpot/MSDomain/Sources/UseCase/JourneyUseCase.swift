//
//  JourneyUseCase.swift
//  UseCase
//
//  Created by 이창준 on 4/27/24.
//

import Foundation

import Entity
import RepositoryProtocol

public final class JourneyUseCase: JourneyUseCaseProtocol {
    // MARK: - Properties

    private let journeyRepository: JourneyRepository

    // MARK: - Initializer

    init(journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
    }

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        []
    }

    public func fetchTravelingJourney() -> Journey? {
        nil
    }

    @discardableResult
    public func beginJourney(startAt coordinate: Coordinate) async throws -> Journey {
        Journey.sample
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: [Coordinate]) async throws -> Journey {
        Journey.sample
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: Coordinate...) async throws -> Journey {
        Journey.sample
    }

    @discardableResult
    public func endJourney() async throws -> Journey {
        Journey.sample
    }

    @discardableResult
    public func cancelJourney() async throws -> Journey {
        Journey.sample
    }

    @discardableResult
    public func deleteJourney(_ journey: Journey) async throws -> Journey {
        Journey.sample
    }
}
