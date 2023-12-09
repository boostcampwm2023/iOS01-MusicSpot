//
//  SpotSaveViewModel.swift
//  Spot
//
//  Created by 전민건 on 11/29/23.
//

import Foundation
import Combine

import MSData
import MSDomain
import MSLogger

public final class SpotSaveViewModel {
    
    public enum Action {
        case startUploadSpot
    }
    
    // MARK: - Properties
    
    private let repository: SpotRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let journeyID: String
    private let coordinate: Coordinate
    
    // MARK: - Initializer
    
    public init(repository: SpotRepository,
                journeyID: String,
                coordinate: Coordinate) {
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
                let spot = CreateSpotRequestDTO(journeyId: self.journeyID,
                                                coordinate: CoordinateDTO(self.coordinate),
                                                timestamp: .now,
                                                photoData: data)
                let result = await self.repository.upload(spot: spot)
                switch result {
                case .success(let spot):
                    MSLogger.make(category: .network).debug("성공적으로 업로드되었습니다: \(spot)")
                case .failure(let error):
                    MSLogger.make(category: .network).error("\(error): 업로드에 실패하였습니다.")
                }
            }
        }
    }
    
}
