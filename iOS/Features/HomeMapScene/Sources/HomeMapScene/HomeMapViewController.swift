//
//  ViewController.swift
//  Test
//
//  Created by 윤동주 on 11/21/23.
//

import UIKit
import MapKit
import CoreLocation

public final class HomeMapViewController: UIViewController {

    // MARK: - Properties

    /// 전체 Map에 대한 View
    var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // 위치 사용 시 사용자의 현 위치 표시
        view.showsUserLocation = false

        // 각도 조절 가능 여부
        view.isRotateEnabled = true

        // 회전 가능 여부
        view.isPitchEnabled = true

        // 나침반 표시 여부
        view.showsCompass = true
        view.userTrackingMode = .followWithHeading

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
    private var polyline: MKPolyline?

    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        // 사용자에게 위치 권한 요청
        manager.requestWhenInUseAuthorization()

        // 위치 데이터의 정확도
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        return manager
    }()

    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureStyle()
        configureLayout()
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.00001, longitudeDelta: 0.00001)
    }

    // MARK: - Functions

    private func configureStyle() {}

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
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let authorizationStatus: CLAuthorizationStatus

        if #available(iOS 14.0, *) {
            authorizationStatus = manager.authorizationStatus
            switch authorizationStatus {

                // 위치 정보 권한 부여받았을 시 실시간 내 위치 업데이트 시작
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
                mapView.setUserTrackingMode(.followWithHeading, animated: true)
                mapView.showsUserLocation = true
                // 5초마다 polyline을 업데이트
                timer = Timer.scheduledTimer(timeInterval: 5,
                                             target: self,
                                             selector: #selector(updatePolyline),
                                             userInfo: nil,
                                             repeats: true)
                // 위치 정보 권한 거부당했을 시
            case .denied, .restricted:
                print("Location services denied or restricted.")

                // 위치 정보 권한 제공 여부 정하지 않았을 시
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default:
                break
            }
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
    }

    /// 현재 보고있는 화면을 내 현위치로 맞춤
    private func centerMapOnLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 500,
                                                  longitudinalMeters: 500)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /// 이전 좌표와 현 좌표를 기준으로 polyline을 추가
    @objc private func updatePolyline() {
        guard let newCoordinate = locationManager.location?.coordinate else { return }
        print("move")
        // Draw polyline
        addPolylineToMap(from: previousCoordinate, to: newCoordinate)

        // Update previous coordinate
        previousCoordinate = newCoordinate
    }

    private func addPolylineToMap(from previousCoordinate: CLLocationCoordinate2D?,
                                  to newCoordinate: CLLocationCoordinate2D) {
        guard let previousCoordinate = previousCoordinate else { return }

        var points: [CLLocationCoordinate2D]

        if let existingPolyline = polyline {
            // If the polyline already exists, add the new coordinate to its points
            points = [existingPolyline.coordinate] + [newCoordinate]
            mapView.removeOverlay(existingPolyline) // Remove the existing polyline
        } else {
            // If the polyline doesn't exist, create a new one with the two coordinates
            points = [previousCoordinate, newCoordinate]
        }

        polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline!) // Add the updated polyline to the map
    }

    /// 위치가 변경될 때마다 하는 작업
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            centerMapOnLocation(location)

            // Initialize the previousCoordinate when the location is first obtained.
            if previousCoordinate == nil {
                previousCoordinate = location.coordinate
            }
        }
    }

    /// 위치 가져오기 실패
    public func locationManager(_ manager: CLLocationManager,
                                didFailWithError error: Error) {
        // 위치 가져오기 실패 에러 Logger 설정
    }
}

// MARK: - MKMapView

extension HomeMapViewController: MKMapViewDelegate {

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
}
