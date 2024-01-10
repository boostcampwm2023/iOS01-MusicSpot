//
//  NavigateMapViewModel.swift
//  Home
//
//  Created by 윤동주 on 11/26/23.
//

import Combine
import CoreLocation
import Foundation

import MSConstants
import MSData
import MSDomain
import MSLogger
import MSUserDefaults

public final class NavigateMapViewModel: MapViewModel {
    
    public enum Action {
        case viewNeedsLoaded
        case visibleJourneysDidUpdated(_ visibleJourneys: [Journey])
    }
    
    public struct State {
        // Passthrough
        public var recordingJourneyShouldResume = PassthroughSubject<RecordingJourney, Never>()
        
        // CurrentValue
        public var visibleJourneys = CurrentValueSubject<[Journey], Never>([])
    }
    
    // MARK: - Properties

    private let journeyRepository: JourneyRepository
    
    public var state = State()
    
    // MARK: - Initializer

    public init(repository: JourneyRepository) {
        self.journeyRepository = repository
    }
    
    // MARK: - Functions
    
    public func trigger(_ action: Action) {
        switch action {
        case .viewNeedsLoaded:
            if let recordingJourney = self.fetchRecordingJourneyIfNeeded() {
                #if DEBUG
                MSLogger.make(category: .navigateMap)
                    .debug("기록중이던 여정이 발견되었습니다: \(recordingJourney)")
                #endif
                self.state.recordingJourneyShouldResume.send(recordingJourney)
            }
        case .visibleJourneysDidUpdated(let visibleJourneys):
            self.state.visibleJourneys.send(visibleJourneys)
        }
    }
    
}

// MARK: - Private Functions

private extension NavigateMapViewModel {
    
    /// 앱 종료 전 진행중이던 여정 기록이 남아있는지 확인합니다.
    /// 진행 중이던 여정 기록이 있다면 해당 데이터를 불러옵니다.
    /// - Returns: 진행 중이던 여정 기록. 없다면 `nil`을 반환합니다.
    func fetchRecordingJourneyIfNeeded() -> RecordingJourney? {
        guard self.journeyRepository.isRecording else { return nil }
        
        return self.journeyRepository.fetchRecordingJourney()
    }
    
}
