//
//  MapViewController+EventListener.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

import MSData
import MSDomain
import MSLogger

// MARK: - NavigateMap

extension MapViewController {
    
    public func visibleJourneysDidUpdated(_ visibleJourneys: [Journey]) {
        guard let viewModel = self.viewModel as? NavigateMapViewModel else { return }
        
        viewModel.trigger(.visibleJourneysDidUpdated(visibleJourneys))
    }
    
}

// MARK: - RecordJourney

extension MapViewController {
    
    public func journeyShouldStarted(_ startedJourney: RecordingJourney) {
        guard let viewModel = self.viewModel as? NavigateMapViewModel else {
            MSLogger.make(category: .home).error("여정이 시작되어야 하지만 이미 Map에서 RecordJourneyViewModel을 사용하고 있습니다.")
            return
        }
        
        let userRepository = UserRepositoryImplementation()
        let journeyRepository = JourneyRepositoryImplementation()
        let recordJourneyViewModel = RecordJourneyViewModel(startedJourney: startedJourney,
                                                            userRepository: userRepository,
                                                            journeyRepository: journeyRepository)
        self.swapViewModel(to: recordJourneyViewModel)
    }
    
    public func journeyShouldStopped() {
        guard let viewModel = self.viewModel as? RecordJourneyViewModel else {
            MSLogger.make(category: .home).error("여정이 종료되어야 하지만 이미 Map에서 NavigateMapViewModel을 사용하고 있습니다.")
            return
        }
        viewModel.trigger(.recordingDidCancelled)
        
        let journeyRepository = JourneyRepositoryImplementation()
        let navigateMapViewModel = NavigateMapViewModel(repository: journeyRepository)
        self.swapViewModel(to: navigateMapViewModel)
    }
    
}
