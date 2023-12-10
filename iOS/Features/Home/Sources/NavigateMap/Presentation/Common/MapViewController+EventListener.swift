//
//  MapViewController+EventListener.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

import MSData
import MSDomain

// MARK: - NavigateMap

extension MapViewController {
    
    public func visibleJourneysDidUpdated(_ visibleJourneys: [Journey]) {
        guard let viewModel = self.viewModel as? NavigateMapViewModel else { return }
        
        viewModel.trigger(.visibleJourneysDidUpdated(visibleJourneys))
    }
    
}

// MARK: - RecordJourney

extension MapViewController {
    
    public func journeyDidStarted(_ startedJourney: RecordingJourney) {
        let userRepository = UserRepositoryImplementation()
        let journeyRepository = JourneyRepositoryImplementation()
        let viewModel = RecordJourneyViewModel(startedJourney: startedJourney,
                                               userRepository: userRepository,
                                               journeyRepository: journeyRepository)
        self.swapViewModel(to: viewModel)
    }
    
    public func journeyDidCancelled() {
        guard let viewModel = self.viewModel as? RecordJourneyViewModel else { return }
        viewModel.trigger(.recordingDidCancelled)
        
        let journeyRepository = JourneyRepositoryImplementation()
        let navigateMapViewModel = NavigateMapViewModel(repository: journeyRepository)
        self.swapViewModel(to: navigateMapViewModel)
    }
    
}
