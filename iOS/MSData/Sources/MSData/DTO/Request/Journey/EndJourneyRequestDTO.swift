//
//  EndJourneyRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct EndJourneyRequestDTO: Encodable {
    
    public let journeyID: String
    /// 완료 버튼을 누른 최종 좌표
    /// > Tip: 서버 전송 실패 시 이전 데이터들도 함께 보내기 위해 배열을 사용합니다.
    public let coordinates: [CoordinateDTO]
    public let endTimestamp: Date
    public let title: String
    public let song: SongDTO
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinates
        case endTimestamp
        case title
        case song
    }
    
}
