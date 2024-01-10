//
//  MapViewController+EventListener.swift
//  NavigateMap
//
//  Created by 이창준 on 2023.12.10.
//

import CoreLocation
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
    
    public func recordingDidStart(_ startedJourney: RecordingJourney) {
        guard self.viewModel is NavigateMapViewModel else {
            MSLogger.make(category: .home).error("여정이 시작되어야 하지만 이미 Map에서 RecordJourneyViewModel을 사용하고 있습니다.")
            return
        }
        
        let userRepository = UserRepositoryImplementation()
        let journeyRepository = JourneyRepositoryImplementation()
        let recordJourneyViewModel = RecordJourneyViewModel(startedJourney: startedJourney,
                                                            userRepository: userRepository,
                                                            journeyRepository: journeyRepository)
        self.swapViewModel(to: recordJourneyViewModel)
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        #if DEBUG
        MSLogger.make(category: .home).debug("여정 기록이 시작되었습니다: \(startedJourney)")
        #endif
    }
    
    public func recordingDidResume(_ recordedJourney: RecordingJourney) {
        let userRepository = UserRepositoryImplementation()
        let journeyRepository = JourneyRepositoryImplementation()
        let recordJourneyViewModel = RecordJourneyViewModel(startedJourney: recordedJourney,
                                                            userRepository: userRepository,
                                                            journeyRepository: journeyRepository)
        self.swapViewModel(to: recordJourneyViewModel)
        
        let coordinates = recordedJourney.coordinates.map {
            CLLocationCoordinate2D(latitude: $0.latitude,
                                   longitude: $0.longitude)
        }
        self.drawPolyline(using: coordinates)
        
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        #if DEBUG
        MSLogger.make(category: .home).debug("여정 기록이 재개되었습니다: \(recordedJourney)")
        #endif
    }
    
    public func recordingDidStop(_ stoppedJourney: RecordingJourney? = nil) {
        guard self.viewModel is RecordJourneyViewModel else {
            MSLogger.make(category: .home).error("여정이 종료되어야 하지만 이미 Map에서 NavigateMapViewModel을 사용하고 있습니다.")
            return
        }
        
        let journeyRepository = JourneyRepositoryImplementation()
        let navigateMapViewModel = NavigateMapViewModel(repository: journeyRepository)
        self.swapViewModel(to: navigateMapViewModel)
        
        self.locationManager.stopUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = false
        
        #if DEBUG
        if let stoppedJourney {
            MSLogger.make(category: .home).debug("여정 기록이 종료되었습니다: \(stoppedJourney)")
        }
        #endif
    }
    
}
