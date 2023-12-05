//
//  JourneyRouter.swift
//  MSData
//
//  Created by 이창준 on 11/26/23.
//

import MSNetworking

public enum JourneyRouter: Router {
    
    /// 여정 기록을 시작합니다.
    case startJourney
    /// 여정 좌표를 기록합니다.
    case recordJourney
    /// 여정 기록을 종료합니다.
    case endJourney
    /// 해당 범위 내 여정들을 반환합니다.
    case checkJourney
    /// 진행 중인 여정이 있는 지 확인하고, 있다면 여정 정보를 반환합니다.
    case loadLastJourney
    
}
