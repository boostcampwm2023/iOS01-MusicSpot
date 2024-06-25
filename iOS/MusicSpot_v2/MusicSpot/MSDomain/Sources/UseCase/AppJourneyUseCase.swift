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
import SSOT

public final class AppJourneyUseCase: JourneyUseCase {
    // MARK: - Properties

    private let appState = StateContainer.default.appState

    private let journeyRepository: JourneyRepository

    // MARK: - Initializer

    init(journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
    }

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws(JourneyError) -> [Journey] {
        do {
            return try await self.journeyRepository.fetchJourneys(in: region)
        } catch {
            throw .repositoryFailure(error)
        }
    }

    public func fetchTravelingJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        do {
            let journey = try await self.journeyRepository.fetchTravelingJourney()
            return journey
        } catch {
            throw .repositoryFailure(error)
        }
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
        var travelingJourney = try await self.fetchTravelingJourney()

        // 진행중인 여정에 새로운 좌표들을 추가한 여정 생성
        travelingJourney.appendCoordinates(consume coordinates)

        // 업데이트 된 Journey를 DataSource에 적용
        do {
            let savedJourney = try await self.journeyRepository.updateJourney(consume travelingJourney)
            return savedJourney
        } catch {
            throw .repositoryFailure(error)
        }
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: Coordinate...) async throws(JourneyError) -> Journey {
        return try await self.recordNewCoordinates(Array(consume coordinates))
    }

    @discardableResult
    public func endJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        var travelingJourney = try await self.fetchTravelingJourney()
        travelingJourney.finish()

        do {
            let endedJourney = try await self.journeyRepository.updateJourney(consume travelingJourney)
            return endedJourney
        } catch {
            throw .repositoryFailure(error)
        }
    }

    @discardableResult
    public func cancelJourney() async throws(JourneyError) -> Journey {
        guard self.appState.isTraveling else {
            throw .emptyTravelingJourney
        }

        let travelingJourney = try await self.fetchTravelingJourney()

        do {
            let cancelledJourney = try await self.journeyRepository.deleteJourney(consume travelingJourney)
            return cancelledJourney
        } catch {
            throw .repositoryFailure(error)
        }
    }

    @discardableResult
    public func deleteJourney(_ journey: Journey) async throws(JourneyError) -> Journey {
        do {
            return try await self.journeyRepository.deleteJourney(journey)
        } catch {
            throw .repositoryFailure(error)
        }
    }
}

// MARK: - Privates

private extension AppJourneyUseCase {
    func createNewJourney(startingAt coordinate: Coordinate) -> Journey {
        let journey = Journey(
            id: UUID().uuidString,
            title: nil,
            date: Timestamp(start: .now),
            coordinates: [coordinate],
            spots: [],
            playlist: [],
            isTraveling: true
        )
        return journey
    }
}
