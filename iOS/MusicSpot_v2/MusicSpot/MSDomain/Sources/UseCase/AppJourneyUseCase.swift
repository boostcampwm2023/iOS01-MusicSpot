//
//  AppJourneyUseCase.swift
//  UseCase
//
//  Created by 이창준 on 4/27/24.
//

import Foundation
import SwiftUI

import Entity
import MSError
import Repository
import Store

public final class AppJourneyUseCase: JourneyUseCase {
    // MARK: - Properties

    @Environment(\.appState)
    private var appState: AppState

    private let journeyRepository: JourneyRepository

    // MARK: - Initializer

    init(journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
    }

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws -> [Journey] {
        try await self.journeyRepository.fetchJourneys(in: region)
    }

    public func fetchTravelingJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        let journey = try await self.journeyRepository.fetchTravelingJourney()
        return journey
    }

    @discardableResult
    public func beginJourney(startAt coordinate: Coordinate) async throws -> Journey {
        // 새로운 여정 생성
        let journey = self.createNewJourney(startingAt: consume coordinate)

        // 생성된 여정 로컬에 저장
        let savedJourney = try await self.journeyRepository.updateJourney(consume journey)

        return savedJourney
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: [Coordinate]) async throws(JourneyError) -> Journey {
        // 진행중인 여정 조회
        let travelingJourney = try await self.fetchTravelingJourney()

        // 진행중인 여정에 새로운 좌표들을 추가한 여정 생성
        let updatedJourney = travelingJourney.appended(consume coordinates)

        // 업데이트 된 Journey를 DataSource에 적용
        let savedJourney = try await self.journeyRepository.updateJourney(consume updatedJourney)

        return savedJourney
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: Coordinate...) async throws -> Journey {
        return try await self.recordNewCoordinates(Array(consume coordinates))
    }

    @discardableResult
    public func endJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        let travelingJourney = try await self.fetchTravelingJourney()

        let endedJourney = try await self.journeyRepository.endJourney(consume travelingJourney)
        return endedJourney
    }

    @discardableResult
    public func cancelJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        let travelingJourney = try await self.fetchTravelingJourney()

        let cancelledJourney = try await self.journeyRepository.endJourney(consume travelingJourney, isCancelled: true)
        return cancelledJourney
    }

    @discardableResult
    public func deleteJourney(_ journey: Journey) async throws -> Journey {
        return try await self.journeyRepository.deleteJourney(journey)
    }
}

// MARK: - Privates

private extension AppJourneyUseCase {
    func createNewJourney(startingAt coordinate: Coordinate) -> Journey {
        let journey = Journey(
            id: UUID().uuidString,
            title: nil,
            date: .startNow(),
            coordinates: [coordinate],
            spots: [],
            playlist: [],
            isTraveling: true
        )
        return journey
    }
}

// MARK: - Extension: Journey

private extension Journey {
    func appended(_ coordinates: [Coordinate]) -> Self {
        Journey(
            id: self.id,
            title: self.title,
            date: self.date,
            coordinates: self.coordinates + coordinates,
            spots: self.spots,
            playlist: self.playlist,
            isTraveling: self.isTraveling
        )
    }
}
