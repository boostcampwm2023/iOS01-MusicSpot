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
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let buttonStackTopSpacing: CGFloat = 50.0
        static let buttonStackTrailingSpacing: CGFloat = 16.0
        
    }
    
    // MARK: - UI Components
    
    /// 전체 Map에 대한 View
    let mapView = MKMapView()
    
    /// HomeMap 내 우상단 3버튼 View
    private lazy var buttonStackView: ButtonStackView = {
        let stackView = ButtonStackView()
        stackView.delegate = self
        return stackView
    }()
    
    // MARK: - Properties
    
    // 임시 위치 정보
    private let tempCoordinate = CLLocationCoordinate2D(latitude: 37.495120492289026, longitude: 126.9553042366186)
    
    public var viewModel: NavigateMapViewModel?
    
    var timer: Timer?
    var previousCoordinate: CLLocationCoordinate2D?
    private var polyline: MKPolyline?
    
    let locationManager = CLLocationManager()
    
    // MARK: - Initializer
    
    public init(viewModel: NavigateMapViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.mapView
        
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.setRegion(MKCoordinateRegion(center: self.tempCoordinate,
                                                      span: MKCoordinateSpan(latitudeDelta: 0.1,
                                                                             longitudeDelta: 0.11)),
                                   animated: true)
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        
        self.configureLayout()
    }
    
    // MARK: - UI Configuration
    
    private func configureLayout() {
        self.view.addSubview(self.buttonStackView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.buttonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                      constant: Metric.buttonStackTopSpacing),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -Metric.buttonStackTrailingSpacing)
        ])
    }
    
}

// MARK: - CLLocationManager

extension NavigateMapViewController: CLLocationManagerDelegate {
    
    /// 위치 정보 권한 변경에 따른 동작
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        case .restricted:
            print("restricted")
        case .denied:
            print("denided")
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("wheninuse")
            self.locationManager.startUpdatingLocation()
        @unknown default:
            print("unknown")
        }
        if #available(iOS 14.0, *) {
            let accuracyState = self.locationManager.accuracyAuthorization
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
            authorizationStatus = self.locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            self.checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        }
    }
    
    //    /// 현재 보고있는 화면을 내 현위치로 맞춤
    //    private func centerMapOnLocation(_ location: CLLocation) {
    //        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
    //                                                  latitudinalMeters: 500,
    //                                                  longitudinalMeters: 500)
    //        mapView.map.setRegion(coordinateRegion, animated: true)
    //    }
    
    @objc
    private func findMyLocation() {
        
        guard self.locationManager.location != nil else {
            self.locationManager.requestWhenInUseAuthorization()
            return
        }
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    /// 이전 좌표와 현 좌표를 기준으로 polyline을 추가
    @objc
    private func updatePolyline() {
        guard let newCoordinate = self.locationManager.location?.coordinate else { return }
        print(newCoordinate)
        // Draw polyline
        self.addPolylineToMap(from: self.previousCoordinate, to: newCoordinate)
        
        // Update previous coordinate
        self.previousCoordinate = newCoordinate
    }
    
    private func addPolylineToMap(from previousCoordinate: CLLocationCoordinate2D?,
                                  to newCoordinate: CLLocationCoordinate2D) {
        guard let previousCoordinate = previousCoordinate else { return }
        
        var points: [CLLocationCoordinate2D]
        
        if let existingPolyline = self.polyline {
            points = [existingPolyline.coordinate] + [newCoordinate]
            self.mapView.removeOverlay(existingPolyline)
        } else {
            points = [previousCoordinate, newCoordinate]
        }
        
        self.polyline = MKPolyline(coordinates: &points, count: points.count)
        self.mapView.addOverlay(self.polyline!) // Add the updated polyline to the map
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        self.checkUserLocationServicesAuthorization()
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        self.checkUserLocationServicesAuthorization()
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
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Custom")
        
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

// MARK: - ButtonView

extension NavigateMapViewController: NavigateMapButtonViewDelegate {
    
    public func mapButtonDidTap() {
        print(#function)
    }
    
    public func userLocationButtonDidTap() {
        print(#function)
    }
    
}
