//
//  ViewController.swift
//  Test
//
//  Created by 윤동주 on 11/21/23.
//

import UIKit
import MapKit
import CoreLocation

final class HomeMapViewController: UIViewController {
    
    // MARK: - Properties
    
    /// 전체 Map에 대한 View
    var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    /// HomeMap 내 우상단 3버튼 View
    var buttonStackView: HomeMapButtonView = {
        let stackView = HomeMapButtonView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    /// 시작하기 Button
    var startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .gray
        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 25
        
        return button
    }()
    
    var timer: Timer?
    var previousCoordinate: CLLocationCoordinate2D?
    
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        return manager
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureStyle()
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        configureLayout()
        
    }
    
    // MARK: - Functions
    
    private func configureStyle() {
        
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        locationManager.delegate = self
        
        // 사용자에게 위치 권한 요청
        locationManager.requestWhenInUseAuthorization()
        
        // 위치 데이터의 정확도
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    private func configureLayout() {
        view.addSubview(mapView)
        view.addSubview(buttonStackView)
        view.addSubview(startButton)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            buttonStackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -27),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            startButton.widthAnchor.constraint(equalToConstant: 186),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    /// 현재 위치를 기준으로 확대하여 표시
    func currentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, span: MKCoordinateSpan) {
        let coordinateLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: span)
        
        mapView.setRegion(locationRegion, animated: true)
    }
}

// MARK: - CLLocationManager

extension HomeMapViewController: CLLocationManagerDelegate {
    
    /// 위치 정보 권한 변경에 따른 동작
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
            // 위치 정보 권한 부여받았을 시 실시간 내 위치 업데이트 시작
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            
            // 5초마다 polyline을 업데이트
            timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updatePolyline), userInfo: nil, repeats: true)
            
            // 위치 정보 권한 거부당했을 시
        case .denied, .restricted:
            print("Location services denied or restricted.")
            
            // 위치 정보 권한 제공 여부 정하지 않았을 시
        case .notDetermined:
            print("Location authorization status not determined yet.")
        default:
            break
        }
    }
    
    /// 현재 보고있는 화면을 내 현위치로 맞춤
    private func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /// 이전 좌표와 현 좌표를 기준으로 polyline을 추가
    @objc private func updatePolyline() {
        guard let newCoordinate = locationManager.location?.coordinate else { return }
        
        // Draw polyline
        addPolylineToMap(from: previousCoordinate, to: newCoordinate)
        
        // Update previous coordinate
        previousCoordinate = newCoordinate
    }
    
    private func addPolylineToMap(from previousCoordinate: CLLocationCoordinate2D?, to newCoordinate: CLLocationCoordinate2D) {
        guard let previousCoordinate = previousCoordinate else { return }
        
        var points: [CLLocationCoordinate2D] = [previousCoordinate, newCoordinate]
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        dump(polyline.coordinate)
        mapView.addOverlay(polyline)
    }
    
    /// 위치가 변경될 때마다 하는 작업
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            centerMapOnLocation(location)
            
            // Initialize the previousCoordinate when the location is first obtained.
            if previousCoordinate == nil {
                previousCoordinate = location.coordinate
            }
        }
    }
    
    /// 위치 가져오기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: - 위치 가져오기 실패 에러 Logger 설정
    }
    
}

// MARK: - MKMapView

extension HomeMapViewController: MKMapViewDelegate {
    
    ///현재까지의 polyline들을 지도 위에 그림
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .orange
        renderer.lineWidth = 5.0
        
        return renderer
    }
}
