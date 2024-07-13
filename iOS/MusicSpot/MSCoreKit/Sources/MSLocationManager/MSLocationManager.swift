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

// MARK: - MSLocationManager

@Observable
public final class MSLocationManager: NSObject {

    // MARK: Lifecycle

    // MARK: - Initializer

    public override init() {
        super.init()
        locationManager.delegate = self
        setUp()
    }

    // MARK: Public

    public var position: MapCameraPosition = .userLocation(fallback: .automatic)

    // MARK: Private

    // MARK: - Properties

    private let locationManager = CLLocationManager()

    // MARK: - Functions

    private func setUp() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            MSLogger.make(category: .locationManager).info("위치 권한 요청 필요")
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()

        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()

        case .restricted, .denied:
            MSLogger.make(category: .locationManager).warning("위치 권한 거절")

        @unknown default:
            MSLogger.make(category: .locationManager).error("알 수 없는 위치 권한 상태")
        }
    }
}

// MARK: CLLocationManagerDelegate

extension MSLocationManager: CLLocationManagerDelegate {
    public func locationManager(
        _: CLLocationManager,
        didFailWithError error: any Error)
    {
        MSLogger.make(category: .locationManager).error("\(error.localizedDescription)")
    }

    public func locationManager(
        _: CLLocationManager,
        didUpdateLocations _: [CLLocation]) { }
}
