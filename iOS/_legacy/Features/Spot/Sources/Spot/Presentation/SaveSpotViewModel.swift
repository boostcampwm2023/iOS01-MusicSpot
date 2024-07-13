//
//  SaveSpotViewModel.swift
//  Spot
//
//  Created by 전민건 on 11/29/23.
//

import Combine
import Foundation

import MSData
import MSDomain
import MSLogger

public final class SaveSpotViewModel {
    public enum Action {
        case uploadSpot(Data)
    }
    
    public struct State {
        // Passthrough
        public var uploadedSpot = PassthroughSubject<(Spot, Data), Never>()
    }
    
    // MARK: - Properties
    
    private let journeyRepository: JourneyRepository
    private let spotRepository: SpotRepository
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let coordinate: Coordinate
    
    public var state = State()
    
    // MARK: - Initializer
    
    public init(journeyRepository: JourneyRepository,
                spotRepository: SpotRepository,
                coordinate: Coordinate) {
        self.journeyRepository = journeyRepository
        self.spotRepository = spotRepository
        self.coordinate = coordinate
    }
}

// MARK: - Interface: Actions

internal extension SaveSpotViewModel {
    func trigger(_ action: Action) {
        switch action {
        case .uploadSpot(let data):
            Task {
                guard let recordingJourneyID = self.journeyRepository.recordingJourneyID else {
                    MSLogger.make(category: .spot).error("recoding 중인 journeyID를 찾지 못하였습니다.")
                    return
                }
                let spot = RequestableSpot(journeyID: recordingJourneyID,
                                           coordinate: self.coordinate,
                                           timestamp: .now,
                                           photoData: data)
                
                let result = await self.spotRepository.upload(spot: spot)
                switch result {
                case .success(let spot):
                    self.state.uploadedSpot.send((spot, data))
                    MSLogger.make(category: .network).debug("성공적으로 업로드되었습니다: \(spot)")
                case .failure(let error):
                    MSLogger.make(category: .network).error("\(error): 업로드에 실패하였습니다.")
                }
            }
        }
    }
}
