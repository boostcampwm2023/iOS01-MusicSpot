//
//  EndJourneyResponseDTO.swift
//  MSData
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public struct EndJourneyResponseDTO: Decodable {
    
    // MARK: - Properties
    
    public let journeyID: UUID
    /// > Tip: 서버 전송 실패 시 이전 데이터들도 함께 보내기 위해 배열을 사용합니다.
    public let coordinates: [CoordinateDTO]
    public let numberOfCoordinates: Int
    public let endTimestamp: Date
    public let song: SongDTO
    
    // MARK: - Initializer
    
    public init(journeyID: UUID,
                coordinates: [CoordinateDTO],
                numberOfCoordinates: Int,
                endTimestamp: Date,
                song: SongDTO) {
        self.journeyID = journeyID
        self.coordinates = coordinates
        self.numberOfCoordinates = numberOfCoordinates
        self.endTimestamp = endTimestamp
        self.song = song
    }
    
}
