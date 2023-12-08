//
//  SpotSaveViewModel.swift
//  Spot
//
//  Created by 전민건 on 11/29/23.
//

import Foundation
import Combine

import MSData
import MSLogger

public final class SpotSaveViewModel {
    
    public enum Action {
        case startUploadSpot
    }
    
    // MARK: - Properties
    
    private var repository: SpotRepository
    private var subscriber: Set<AnyCancellable> = []
    private let journeyID: String
    private let coordinate: String
    
    // MARK: - Initializer
    
    public init(repository: SpotRepository,
                journeyID: String,
                coordinate: String) {
        self.repository = repository
        self.journeyID = journeyID
        self.coordinate = coordinate
    }
    
}

// MARK: - Interface: Actions

internal extension SpotSaveViewModel {
    
    func trigger(_ action: Action, using data: Data) {
        switch action {
        case .startUploadSpot:
            Task {
                let dateFormatter = ISO8601DateFormatter()
                        dateFormatter.formatOptions.insert(.withFractionalSeconds)
                let spot = CreateSpotRequestDTO(journeyId: self.journeyID,
                                                coordinate: self.coordinate,
                                                timestamp: dateFormatter.string(from: Date()),
                                                photoData: data)
                let result = await self.repository.upload(spot: spot)
                switch result {
                case .success(let spot):
//                    if spot.journeyID == self.journeyID {
                    MSLogger.make(category: .network).debug("성공적으로 업로드되었습니다.")
//                    } else {
//                        MSLogger.make(category: .network).debug("journey id가 일치하지 않습니다.")
//                    }
                case .failure(let error):
                    MSLogger.make(category: .network).debug("\(error): 업로드에 실패하였습니다.")
                }
            }
        }
    }
    
}
