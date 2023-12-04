//
//  NavigateMapViewController.swift
//  Home
//
//  Created by 윤동주 on 11/21/23.
//

import CoreLocation
import UIKit
import MapKit

import MSUIKit

public final class NavigateMapViewController: UIViewController {

    // MARK: - Properties
    
    // 임시 위치 정보
    let tempCoordinate = CLLocationCoordinate2D(latitude: 37.495120492289026, longitude: 126.9553042366186)

    /// 전체 Map에 대한 View
    let mapView = MapView()

    /// HomeMap 내 우상단 3버튼 View
    var buttonStackView: NavigateMapButtonView = {
        let stackView = NavigateMapButtonView()

        return stackView
    }()
    
    @objc func findMyLocation() {
        
        guard let currentLocation = locationManager.location else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        mapView.map.showsUserLocation = true
        
        mapView.map.setUserTrackingMode(.follow, animated: true)
        
    }

    var timer: Timer?
    var previousCoordinate: CLLocationCoordinate2D?
    private var polyline: MKPolyline?

    let locationManager = CLLocationManager()

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mapView
        
        locationManager.requestWhenInUseAuthorization()
        mapView.map.setRegion(MKCoordinateRegion(center: tempCoordinate,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.11)),
                              animated: true)
        
        mapView.map.delegate = self
        
        locationManager.delegate = self
    
        configureLayout()
        configureStyle()
    }

    // MARK: - Functions

    private func configureStyle() {}

    private func configureLayout() {
        view.addSubview(buttonStackView)
        
        mapView.map.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.mapView.map.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.map.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.map.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.mapView.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            self.buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            self.buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
}

// MARK: - CLLocationManager

extension NavigateMapViewController: CLLocationManagerDelegate {

    /// 위치 정보 권한 변경에 따른 동작
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
        case .denied:
            print("denided")
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }

//    /// 현재 보고있는 화면을 내 현위치로 맞춤
//    private func centerMapOnLocation(_ location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
//                                                  latitudinalMeters: 500,
//                                                  longitudinalMeters: 500)
//        mapView.map.setRegion(coordinateRegion, animated: true)
//    }

    /// 이전 좌표와 현 좌표를 기준으로 polyline을 추가
    @objc private func updatePolyline() {
        guard let newCoordinate = locationManager.location?.coordinate else { return }
        print(newCoordinate)
        // Draw polyline
        self.addPolylineToMap(from: previousCoordinate, to: newCoordinate)

        // Update previous coordinate
        previousCoordinate = newCoordinate
    }

    private func addPolylineToMap(from previousCoordinate: CLLocationCoordinate2D?,
                                  to newCoordinate: CLLocationCoordinate2D) {
        guard let previousCoordinate = previousCoordinate else { return }

        var points: [CLLocationCoordinate2D]

        if let existingPolyline = polyline {
            points = [existingPolyline.coordinate] + [newCoordinate]
            mapView.map.removeOverlay(existingPolyline)
        } else {
            points = [previousCoordinate, newCoordinate]
        }

        polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.map.addOverlay(polyline!) // Add the updated polyline to the map
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkUserLocationServicesAuthorization()
    }

    /// 위치 가져오기 실패
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        // 위치 가져오기 실패 에러 Logger 설정
    }
}

// MARK: - MKMapView

extension NavigateMapViewController: MKMapViewDelegate {

    /// 현재까지의 polyline들을 지도 위에 그림
    public func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0

        return renderer
    }
    
    /// 재사용 할 수 있는 Annotation 만들어두기
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = self.mapView.map.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Custom")
            annotationView?.canShowCallout = true
            
            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
            
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = UIImage(named: "Circle")
        
        return annotationView
    }
}
