//
//  MapViewController+EventListener.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

import MSDomain

extension MapViewController {
    
    public func journeyDidStarted(_ startedJourney: RecordingJourney) {
        self.viewModel = RecordJourneyViewModel(startedJourney: startedJourney)
    }
    
}
