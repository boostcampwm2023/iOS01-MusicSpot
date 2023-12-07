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

import MSData
import MSDomain
import MSImageFetcher
import MSLogger
import MSNetworking
import MSUIKit


public protocol HomeViewModelDelegate {
    func fetchJourneys(from coordinates: (Coordinate, Coordinate))
}

public final class NavigateMapViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let locationAlertTitle = "위치 권한"
        static let locationAlertMessage = "위치 권한을 허용하시지 않아서 위치 접근이 불가능합니다."
        static let locationAlertConfirm = "확인"
        
    }
    
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
    
    public var currentCoordinate: (minCoordinate: Coordinate, maxCoordinate: Coordinate) {
        let region = self.mapView.region
        let minCoordinate = Coordinate(latitude: region.center.latitude + region.span.latitudeDelta / 2,
                                       longitude: region.center.longitude - region.span.longitudeDelta / 2)
        let maxCoordinate = Coordinate(latitude: region.center.latitude - region.span.latitudeDelta / 2,
                                       longitude: region.center.longitude + region.span.longitudeDelta / 2)
        return (minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
    }
    
    private let locationManager = CLLocationManager()
    
    private let viewModel: NavigateMapViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var homeViewModelDelegate: HomeViewModelDelegate?
    
    private var msNetworking = MSNetworking(session: URLSession.shared)
    
    internal var navigateMapRouter: JourneyRouter?
    
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
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.configureLayout()
        self.bind()
    }
    
    // MARK: - UI Configuration
    
    private func configureLayout() {
        self.view = self.mapView
        
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
    
    func addAnnotations(journeys: [Journey]) {
        let datas = journeys.flatMap { journey in
            journey.spots.map { (location: journey.title, spot: $0) }
        }
        
        Task {
            await withThrowingTaskGroup(of: Bool.self) { group in
                for (location, spot) in datas {
                    group.addTask {
                        // TODO: Key 수정
                        guard let photoData = await MSImageFetcher.shared.fetchImage(from: spot.photoURL,
                                                                                     forKey: spot.photoURL.absoluteString) else {
                            throw ImageFetchError.imageFetchFailed
                        }
                        
                        let coordinate = CLLocationCoordinate2D(latitude: spot.coordinate.latitude,
                                                                longitude: spot.coordinate.longitude)
                        
                        await self.mapView.addAnnotation(title: location,
                                                         coordinate: coordinate,
                                                         photoData: photoData)
                        
                        return true
                    }
                }
            }
        }
    }
    
    func drawPolyLines(journeys: [Journey]) {
        journeys.forEach { journey in
            Task {
                self.mapView.createPolyLine(coordinates: journey.coordinates)
            }
        }
    }

    // MARK: - Combine Binding
    
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
        self.checkUserLocationServicesAuthorization()
    }
    
    /// 위치 정보 권한 상태에 따른 동작
    func checkCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            // 앱 사용 중 위치 권한 요청
            self.locationManager.requestWhenInUseAuthorization()
            
            // 위치 접근 시작
            self.locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let sheet = UIAlertController(title: Typo.locationAlertTitle,
                                          message: Typo.locationAlertMessage,
                                          preferredStyle: .alert)
            sheet.addAction(UIAlertAction(title: Typo.locationAlertConfirm, style: .default))
            self.present(sheet, animated: true)
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

extension NavigateMapViewController: ButtonStackViewDelegate {
    
    /// 현재 지도에서 보이는 범위 내의 모든 Spot들을 보여줌.
    public func mapButtonDidTap() {
        print(#function, "현재 지도에서 보이는 범위 내의 모든 Spot들을 보여줍니다.")
        Task{
            await self.loadJourneys()
        }
    }
    
    /// 현재 내 위치를 중앙에 위치.
    public func userLocationButtonDidTap() {
        mapView.setUserTrackingMode(.followWithHeading, animated: false)
    }
    
}


// MARK: - Networking

extension NavigateMapViewController {
    
    // MARK: - Functions
    
    func loadJourneys() async {
//        guard let router else {
//            MSLogger.make(category: .spot).debug("journeyID와 coordinate ID가 view model에 전달되지 않았습니다.")
//            return
//        }
//        let timestamp = Data().base64EncodedString()
//        print(timestamp)
        
        let router = JourneyRouter.checkJourney(userID: UUID(uuidString: "ab4068ef-95ed-40c3-be6d-3db35df866b9")!,
                                                minCoordinate: CoordinateDTO(latitude: 36.5, longitude: 125.5),
                                                maxCoordinate: CoordinateDTO(latitude: 38.5, longitude: 127.5))
        let result = await self.msNetworking.request(CheckJourneyResponseDTO.self, router: router)
        switch result {
        case .success(let journeys):
            print(journeys)
        case .failure(let error):
            print(error)
        }
        
//        self.msNetworking.request(CheckJourneyResponseDTO.self, router: router)
//            .sink { response in
//                switch response {
//                case .failure(let error):
//                    MSLogger.make(category: .network).debug("\(error): 정상적으로 Journey 목록을 서버에서 가져오지 못하였습니다.")
//                default:
//                    return
//                }
//            } receiveValue: { journey in
//                print(journey)
//            }
//            .store(in: &cancellables)
    }
}

