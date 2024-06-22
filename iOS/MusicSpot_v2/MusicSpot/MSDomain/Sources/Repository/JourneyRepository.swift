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
    /// 사각형 내부에 존재하는 Journey들의 목록을 불러옵니다.
    /// - Parameters:
    ///   - region: Journey 목록을 불러올 사각형 지역
    /// - Returns: `region` 내부에 존재하는 Journey 목록
    func fetchJourneys(in region: Region) async throws -> [Journey]

    /// 현재 진행중인 여정에 대한 정보를 불러옵니다.
    /// - Returns: 진행 중인 여정
    func fetchTravelingJourney() async throws(JourneyError) -> Journey

    /// 여정을 업데이트 합니다. 기존에 존재하지 않던 여정이라면 새로 생성합니다.
    /// - Parameters:
    ///   - journey: 업데이트 할 여정
    /// - Returns: 업데이트 된 여정에 대한 정보를 담은 인스턴스
    @discardableResult
    func updateJourney(_ journey: Journey) async throws(JourneyError) -> Journey
    @discardableResult
    func endJourney(_ journey: Journey, isCancelled: Bool) async throws(JourneyError) -> Journey

    /// 여정을 삭제합니다.
    /// - Parameters:
    ///   - journey: 삭제할 여정
    ///   - Returns: 삭제된 여정에 대한 정보를 담은 인스턴스
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
