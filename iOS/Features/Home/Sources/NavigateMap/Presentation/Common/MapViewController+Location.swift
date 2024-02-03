//
//  MapViewController+Location.swift
//  NavigateMap
//
//  Created by 이창준 on 2024.02.02.
//

import CoreLocation
import UIKit

import MSLogger

extension MapViewController: CLLocationManagerDelegate {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let locationAlertTitle = "위치 권한이 허용되지 않음"
        static let locationAlertMessage = "MusicSpot은 위치 권한을 필요합니다. 설정에서 \"앱을 사용하는 동안\" 이상의 권한을 허용해주세요."
        static let locationAlertCancel = "취소"
        static let locationAlertSettings = "설정"
        
    }
    
    // MARK: - Location Manager: didUpdateLocations
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        // TODO: Location 동작 개선
        guard self.timeRemaining == .zero,
              let newCurrentLocation = locations.last,
              let recordJourneyViewModel = self.viewModel as? RecordJourneyViewModel else {
            return
        }
        
        let coordinate2D = CLLocationCoordinate2D(latitude: newCurrentLocation.coordinate.latitude,
                                                  longitude: newCurrentLocation.coordinate.longitude)
        recordJourneyViewModel.trigger(.tenLocationsDidRecorded(coordinate2D))
    }
    
    // MARK: - Location Manager: didFailWithError
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        MSLogger.make(category: .navigateMap).error("\(error.localizedDescription)")
    }
    
    // MARK: - Location Manager: didChangeAuthorization
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task.detached {
            await self.handleAuthorizationChange(manager)
        }
    }
    
    private func handleAuthorizationChange(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied || manager.authorizationStatus == .restricted {
            let alert = UIAlertController(title: Typo.locationAlertTitle,
                                          message: Typo.locationAlertMessage,
                                          preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: Typo.locationAlertCancel, style: .cancel)
            alert.addAction(cancelAction)
            
            let settingsAction = UIAlertAction(title: Typo.locationAlertSettings, style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(settingsAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
    
}
