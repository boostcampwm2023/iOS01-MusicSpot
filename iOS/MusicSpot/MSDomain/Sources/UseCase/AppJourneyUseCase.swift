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

// MARK: - AppJourneyUseCase

public final class AppJourneyUseCase: JourneyUseCase {

    // MARK: Lifecycle

    // MARK: - Initializer

    init(journeyRepository: JourneyRepository) {
        self.journeyRepository = journeyRepository
    }

    // MARK: Public

    // MARK: - Functions

    public func fetchJourneys(in region: Region) async throws(JourneyError) -> [Journey] { // swiftlint:disable:this all
        do {
            return try await journeyRepository.fetchJourneys(in: region)
        } catch {
            throw .repositoryError(error)
        }
    }

    public func fetchTravelingJourney() async throws(JourneyError) -> Journey { // swiftlint:disable:this all
        guard appState.isTraveling else {
            throw .noTravelingJourney
        }

        do {
            return try await journeyRepository.fetchTravelingJourney()
        } catch {
            throw .repositoryError(error)
        }
    }

    @discardableResult
    public func beginJourney(startAt coordinate: Coordinate) async throws -> Journey {
        // 새로운 여정 생성
        let journey = createNewJourney(startingAt: consume coordinate)

        // 생성된 여정 로컬에 저장
        return try await journeyRepository.updateJourney(consume journey)
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: [Coordinate]) async throws(JourneyError)
        -> Journey
    { // swiftlint:disable:this all
        // 진행중인 여정 조회
        var travelingJourney = try await fetchTravelingJourney()

        // 진행중인 여정에 새로운 좌표들을 추가한 여정 생성
        travelingJourney.appendCoordinates(consume coordinates)

        // 업데이트 된 Journey를 DataSource에 적용
        do {
            return try await journeyRepository.updateJourney(consume travelingJourney)
        } catch {
            throw .repositoryError(error)
        }
    }

    @discardableResult
    public func recordNewCoordinates(_ coordinates: Coordinate...) async throws(JourneyError)
        -> Journey
    { // swiftlint:disable:this all
        try await recordNewCoordinates(Array(consume coordinates))
    }

    @discardableResult
    public func endJourney() async throws(JourneyError) -> Journey { // swiftlint:disable:this all
        guard appState.isTraveling else {
            throw .noTravelingJourney
        }

        var travelingJourney = try await fetchTravelingJourney()
        travelingJourney.finish()

        do {
            return try await journeyRepository.updateJourney(consume travelingJourney)
        } catch {
            throw .repositoryError(error)
        }
    }

    @discardableResult
    public func cancelJourney() async throws(JourneyError) -> Journey { // swiftlint:disable:this all
        guard appState.isTraveling else {
            throw .noTravelingJourney
        }

        let travelingJourney = try await fetchTravelingJourney()

        do {
            return try await journeyRepository.deleteJourney(consume travelingJourney)
        } catch {
            throw .repositoryError(error)
        }
    }

    @discardableResult
    public func deleteJourney(_ journey: Journey) async throws(JourneyError) -> Journey { // swiftlint:disable:this all
        do {
            return try await journeyRepository.deleteJourney(journey)
        } catch {
            throw .repositoryError(error)
        }
    }

    // MARK: Private

    // MARK: - Properties

    private let appState = StateContainer.default.appState
    private let journeyRepository: JourneyRepository
}

// MARK: - Privates

extension AppJourneyUseCase {
    private func createNewJourney(startingAt coordinate: Coordinate) -> Journey {
        Journey(
            id: UUID().uuidString,
            title: nil,
            date: Timestamp(start: .now),
            coordinates: [coordinate],
            spots: [],
            playlist: [],
            isTraveling: true)
    }
}
