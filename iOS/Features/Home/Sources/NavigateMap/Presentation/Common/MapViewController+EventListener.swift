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
        let journeyRepository = JourneyRepositoryImplementation()
        let viewModel = RecordJourneyViewModel(startedJourney: startedJourney, journeyRepository: journeyRepository)
        self.swapViewModel(to: viewModel)
    }
    
    public func journeyDidCancelled() {
        
    }
    
}
