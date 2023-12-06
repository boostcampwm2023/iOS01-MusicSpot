//
//  RecordSpotRequestDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct RecordSpotRequestDTO {
    
    // MARK: - Properties
    
    public let journeyID: String
    /// 저장할 좌표 값
    /// > Tip: 서버 전송 실패 시 이전 데이터들도 함께 보내기 위해 배열을 사용합니다.
    public let coordinates: [CoordinateDTO]
    
    // MARK: - Initializer
    
    public init(journeyID: String,
                coordinates: [CoordinateDTO]) {
        self.journeyID = journeyID
        self.coordinates = coordinates
    }
    
}

// MARK: - Encodable

extension RecordSpotRequestDTO: Encodable {
    
    enum CodingKeys: String, CodingKey {
        case journeyID = "journeyId"
        case coordinates
    }
    
}
