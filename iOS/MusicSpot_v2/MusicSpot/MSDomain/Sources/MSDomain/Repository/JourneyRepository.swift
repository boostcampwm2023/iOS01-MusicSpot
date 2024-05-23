//
//  JourneyRepository.swift
//  MSDomain
//
//  Created by 이창준 on 2023.12.24.
//

import Foundation

import Entity

public protocol JourneyRepository {
    
    var isRecording: Bool { get }
    var recordingJourneyID: String? { get }
    
    /// 사각형 내부에 존재하는 Journey들의 목록을 불러옵니다.
    /// - Parameters:
    ///   - region: Journey 목록을 불러올 사각형 지역
    /// - Returns: `region` 내부에 존재하는 Journey 목록
    func fetchJourneys(in region: Region) async throws -> [Journey]
    
    /// 현재 진행중인 여정에 대한 정보를 불러옵니다.
    func fetchRecordingJourney() -> Journey?
    
    /// 새로운 여정을 시작합니다.
    /// - Parameters:
    ///   - coordinate: 여정이 시작되는 좌표
    /// - Returns: 시작된 여정에 대한 정보를 담은 인스턴스
    @discardableResult
    func startJourney(at coordinate: Coordinate) async throws -> Journey
    
    /// 진행중인 여정에 새로운 좌표를 기록합니다.
    /// - Parameters:
    ///   - coordinates: 새로운 좌표 목록
    /// - Returns: 새로운 좌표가 기록된 여정 인스턴스
    @discardableResult
    func recordJourney(coordinates: [Coordinate]) async throws -> Journey
    
    /// 진행중인 여정을 종료합니다. 종료된 여정은 여정 목록에 저장되고, 서버에도 전송됩니다.
    /// - Returns: 종료된 여정에 대한 정보를 담은 여정 인스턴스
    func endJourney() async throws -> Journey
    
    /// 진행중인 여정을 취소합니다. 취소된 여정은 여정 목록에 저장되지 않습니다.
    /// - Returns: 취소된 여정에 대한 정보를 담은 여정 인스턴스
    func cancelJourney() async throws -> Journey
    
    /// 기록된 여정 중 하나를 삭제합니다.
    /// - Returns: 삭제된 여정에 대한 정보를 담은 여정 인스턴스
    func deleteJourney(_ journey: Journey) async throws -> Journey
    
}
