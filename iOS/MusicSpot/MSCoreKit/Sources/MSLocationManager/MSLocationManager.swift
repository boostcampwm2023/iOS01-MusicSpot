//
//  MSLocationManager.swift
//  MSLocationManager
//
//  Created by 이창준 on 4/19/24.
//

import CoreLocation
import MapKit
import Observation
import SwiftUI

import MSLogger

@Observable
public final class MSLocationManager: NSObject {
    // MARK: - Properties

    private let locationManager = CLLocationManager()

    public var position: MapCameraPosition = .userLocation(fallback: .automatic)

    // MARK: - Initializer

    public override init() {
        super.init()
        self.locationManager.delegate = self
        self.setUp()
    }

    // MARK: - Functions

    private func setUp() {
        switch self.locationManager.authorizationStatus {
        case .notDetermined:
            MSLogger.make(category: .locationManager).info("위치 권한 요청 필요")
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        case .restricted, .denied:
            MSLogger.make(category: .locationManager).warning("위치 권한 거절")
        @unknown default:
            MSLogger.make(category: .locationManager).error("알 수 없는 위치 권한 상태")
        }
    }
}

extension MSLocationManager: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        MSLogger.make(category: .locationManager).error("\(error.localizedDescription)")
    }

    public func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
    }
}
