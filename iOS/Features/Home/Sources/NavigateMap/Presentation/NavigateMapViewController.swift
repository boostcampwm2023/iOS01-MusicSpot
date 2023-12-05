//
//  NavigateMapViewController.swift
//  Home
//
//  Created by 윤동주 on 11/21/23.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import MSUIKit
import MSLogger
import MSData
import MSImageFetcher

public final class NavigateMapViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let buttonStackTopSpacing: CGFloat = 50.0
        static let buttonStackTrailingSpacing: CGFloat = 16.0
        
    }
    
    // MARK: - UI Components
    
    /// HomeMap 내 우상단 3버튼 View
    private lazy var buttonStackView: ButtonStackView = {
        let stackView = ButtonStackView()
        stackView.delegate = self
        return stackView
    }()
    
    private var mapView = MSMapView()
    
    // MARK: - Properties
    
    private let locationManager = CLLocationManager()
    
    private let viewModel: NavigateMapViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
//    private var previousCoordinate: CLLocationCoordinate2D?
//    private var polyline: MKPolyline?
    
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
        print(#function)
        super.viewDidLoad()
        self.view = self.mapView
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.configureLayout()
        self.viewModel.trigger(.viewNeedsLoaded)
        self.bind()
        
    }
    
    // MARK: - UI Configuration
    
    private func configureLayout() {
        print(#function)
        self.view.addSubview(self.buttonStackView)
        
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            self.buttonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                      constant: Metric.buttonStackTopSpacing),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -Metric.buttonStackTrailingSpacing)
        ])
    }
    
    // MARK: - Functions

    /// iOS 버젼에 따른 분기 처리 후 'iOS 위치 서비스 사용 중 여부' 확인
    func checkUserLocationServicesAuthorization() {
        let authorizationStatus = self.locationManager.authorizationStatus
        
        // 'iOS 위치 서비스 사용 중 여부' 확인
        DispatchQueue.global().async {
            // 위치 서비스 사용 중이라면
            if CLLocationManager.locationServicesEnabled() {
                // 위치 권한 확인 및 권한 요청
                self.checkCurrentLocationAuthorization(authorizationStatus)
            }
            
        }
        
    }
    
    func addAnnotations(journeys: [Journey]){
        
        journeys.forEach { journey in
            journey.spots.forEach { spot in
                Task {
                    guard let photoData = await MSImageFetcher.shared.fetchImage(from: spot.photoURL, forKey: spot.journeyID.uuidString)
                    else { return }
                    
                    let coordinate = CLLocationCoordinate2D(latitude: spot.coordinate.latitude, longitude: spot.coordinate.longitude)
                    self.mapView.addAnnotation(title: journey.location, coordinate: coordinate, photoData: photoData)
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
    
    func bind() {
        self.viewModel.state.journeys
            .receive(on: DispatchQueue.main)
            .sink { journeys in
                self.addAnnotations(journeys: journeys)
                self.drawPolyLines(journeys: journeys)
            }
            .store(in: &self.cancellables)
    }
    
}

// MARK: - CLLocationManager

extension NavigateMapViewController: CLLocationManagerDelegate {
    
    /// 앱에 대한 권한 설정이 변경되면 호출
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        self.checkUserLocationServicesAuthorization()
    }
    
    /// 위치 정보 권한 상태에 따른 동작
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        print(#function)
        switch authorizationStatus {
        case .notDetermined:
            
            // 앱 사용 중 위치 권한 요청
            self.locationManager.requestWhenInUseAuthorization()
            
            // 위치 접근 시작
            self.locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let sheet = UIAlertController(title: "위치 권한",
                                          message: "위치 권한을 허용하시지 않아서 위치 접근이 불가능합니다.",
                                          preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: "확인", style: .default))
            present(sheet, animated: true)
        case .authorizedAlways:
            // 위치 접근 시작
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            // 위치 접근 시작
            self.locationManager.startUpdatingLocation()
        @unknown default:
            MSLogger.make(category: .home).error("잘못된 위치 권한입니다.")
        }
        
        // 정확도에 대한 정보 확인
        let accuracyState = self.locationManager.accuracyAuthorization
        switch accuracyState {
        case .fullAccuracy:
            MSLogger.make(category: .home).log("위치 정보 정확도가 높습니다.")
        case .reducedAccuracy:
            MSLogger.make(category: .home).log("위치 정보 정확도가 낮습니다.")
        default:
            MSLogger.make(category: .home).error("잘못된 위치 정보 정확도에 대한 값입니다.")
        }
    }
    
}

// MARK: - ButtonView

extension NavigateMapViewController: NavigateMapButtonViewDelegate {
    
    /// 현재 지도에서 보이는 범위 내의 모든 Spot들을 보여줌.
    public func mapButtonDidTap() {
        print(#function, "현재 지도에서 보이는 범위 내의 모든 Spot들을 보여줍니다.")
    }
    
    /// 현재 내 위치를 중앙에 위치.
    public func userLocationButtonDidTap() {
        mapView.setUserTrackingMode(.followWithHeading, animated: false)
    }
    
}
