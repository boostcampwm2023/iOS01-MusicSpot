//
//  JourneyRouter.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import Foundation

import MSNetworking

public enum JourneyRouter: Router {
    
    /// 여정 기록을 시작합니다.
    case startJourney(dto: StartJourneyRequestDTO)
    /// 여정의 각 좌표를 기록합니다.
    case recordCoordinate(dto: RecordCoordinateRequestDTO)
    /// 여정 기록을 종료합니다.
    case endJourney(dto: EndJourneyRequestDTO)
    /// 해당 범위 내 여정들을 반환합니다.
    case checkJourney(userID: UUID, minCoordinate: CoordinateDTO, maxCoordinate: CoordinateDTO)
    /// 진행 중인 여정이 있는 지 확인하고, 있다면 여정 정보를 반환합니다.
    case loadLastJourney(userID: UUID)
    /// 여정 ID에 따른 여정 삭제
    case deleteJourney(dto: DeleteJourneyRequestDTO)
    
}
