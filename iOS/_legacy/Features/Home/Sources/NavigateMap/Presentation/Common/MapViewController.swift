//
//  MapViewController.swift
//  Home
//
//  Created by 윤동주 on 11/21/23.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import MSDomain
import MSImageFetcher
import MSLogger
import MSUIKit

public final class MapViewController: UIViewController {
    // MARK: - Constants
    
    private enum Typo {
        static let locationAlertTitle = "위치 권한이 허용되지 않음"
        static let locationAlertMessage = "MusicSpot은 위치 권한을 필요합니다. 설정에서 \"앱을 사용하는 동안\" 이상의 권한을 허용해주세요."
        static let locationAlertCancel = "취소"
        static let locationAlertSettings = "설정"
    }
    
    private enum Metric {
        static let buttonStackTopSpacing: CGFloat = 50.0
        static let buttonStackTrailingSpacing: CGFloat = 16.0
        static let lineWidth: CGFloat = 5.0
    }
    
    // MARK: - UI Components
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        
        mapView.register(SpotAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: SpotAnnotationView.identifier)
        mapView.register(ClusterAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        
        return mapView
    }()
    
    private let gradientLayer: MSGradientLayer = {
        let gradientLayer = MSGradientLayer()
        gradientLayer.gradientColors = [
            .msColor(.primaryBackground).withAlphaComponent(.zero),
            .msColor(.primaryBackground).withAlphaComponent(0.7)
        ]
        gradientLayer.locations = [0.55, 0.95]
        return gradientLayer
    }()
    
    /// HomeMap 내 우상단 버튼 View
    private lazy var buttonStackView: ButtonStackView = {
        let stackView = ButtonStackView()
        stackView.delegate = self
        return stackView
    }()
    
    // MARK: - Properties
    
    public weak var delegate: MapViewControllerDelegate?
    var viewModel: (any MapViewModel)?
    
    internal let locationManager = CLLocationManager()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private var timeRemaining: Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: .now) % 5
    }
    
    /// 지도 상에 보이는 좌표 범위
    /// - Parameters:
    ///   - minCoordinate: 우측 하단 좌표
    ///   - maxCoordinate: 좌측 상단 좌표
    public var visibleCoordinates: (minCoordinate: Coordinate, maxCoordinate: Coordinate) {
        let region = self.mapView.region
        let minCoordinate = Coordinate(latitude: region.center.latitude + region.span.latitudeDelta / 2,
                                       longitude: region.center.longitude - region.span.longitudeDelta / 2)
        let maxCoordinate = Coordinate(latitude: region.center.latitude - region.span.latitudeDelta / 2,
                                       longitude: region.center.longitude + region.span.longitudeDelta / 2)
        return (minCoordinate: minCoordinate, maxCoordinate: maxCoordinate)
    }
    
    public var userLocation: CLLocation? {
        return self.locationManager.location
    }
    
    public var currentUserCoordinate: Coordinate? {
        guard let currentUserCoordinate2D = self.userLocation?.coordinate else { return nil }
        let coordinate = Coordinate(latitude: currentUserCoordinate2D.latitude,
                                    longitude: currentUserCoordinate2D.longitude)
        return coordinate
    }
    
    // MARK: - Initializer
    
    public init(viewModel: any MapViewModel,
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
        
        self.configureLayout()
        self.configureStyles()
        self.configureCoreLocation()
        self.bind(self.viewModel)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.gradientLayer.frame = self.view.bounds
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.updateGradientColors()
    }
    
    // MARK: - Combine Binding
    
    func swapViewModel(to viewModel: any MapViewModel) {
        self.viewModel = nil
        self.cancellables.forEach { $0.cancel() }
        
        self.bind(viewModel)
    }
    
    private func bind(_ viewModel: (any MapViewModel)?) {
        self.viewModel = viewModel
        
        if let navigateMapViewModel = viewModel as? NavigateMapViewModel {
            self.bind(navigateMapViewModel)
            MSLogger.make(category: .home).debug("Map에 NavigateMapViewModel을 바인딩 했습니다.")
            return
        }
        
        if let recordJourneyViewModel = viewModel as? RecordJourneyViewModel {
            self.bind(recordJourneyViewModel)
            MSLogger.make(category: .home).debug("Map에 RecordJourneyViewModel을 바인딩 했습니다.")
            return
        }
        
        MSLogger.make(category: .home).warning("Map에 ViewModel을 바인딩하지 못했습니다.")
    }
    
    private func bind(_ viewModel: NavigateMapViewModel) {
        viewModel.state.visibleJourneys
            .receive(on: DispatchQueue.main)
            .sink { [weak self] journeys in
                self?.clearOverlays()
                self?.clearAnnotations()
                self?.addAnnotations(with: journeys)
                self?.drawJourneyListPolylines(with: journeys)
            }
            .store(in: &self.cancellables)
    }
    
    private func bind(_ viewModel: RecordJourneyViewModel) {
        viewModel.state.previousCoordinate
            .zip(viewModel.state.currentCoordinate)
            .compactMap { previousCoordinate, currentCoordinate -> (CLLocationCoordinate2D, CLLocationCoordinate2D)? in
                guard let previousCoordinate = previousCoordinate,
                      let currentCoordinate = currentCoordinate else {
                    return nil
                }
                return (previousCoordinate, currentCoordinate)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] previousCoordinate, currentCoordinate in
                let points = [previousCoordinate, currentCoordinate]
                self?.drawPolyline(using: points)
            }
            .store(in: &self.cancellables)
        
        viewModel.state.filteredCoordinate
            .receive(on: DispatchQueue.main)
            .sink { coordinate in
                guard let filteredCoordinate2D = coordinate else { return }
                viewModel.trigger(.locationDidUpdated(filteredCoordinate2D))
                viewModel.trigger(.locationsShouldRecorded([filteredCoordinate2D]))
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions: Annotation
    
    /// 식별자를 갖고 Annotation view 생성
    func addAnnotationView(using annotation: SpotAnnotation,
                           on mapView: MKMapView) -> MKAnnotationView {
        return mapView.dequeueReusableAnnotationView(withIdentifier: SpotAnnotationView.identifier,
                                                     for: annotation)
    }
    
    private func addAnnotations(with journeys: [Journey]) {
        let datas = journeys.flatMap { journey in
            journey.spots.map { (location: journey.title, spot: $0) }
        }
        
        Task {
            await withThrowingTaskGroup(of: Void.self) { group in
                for (location, spot) in datas {
                    group.addTask {
                        let imageFetcher = MSImageFetcher.shared
                        guard let photoData = await imageFetcher.fetchImage(from: spot.photoURL,
                                                                            forKey: spot.photoURL.paath()) else {
                            throw ImageFetchError.imageFetchFailed
                        }
                        
                        let coordinate = CLLocationCoordinate2D(latitude: spot.coordinate.latitude,
                                                                longitude: spot.coordinate.longitude)
                        
                        await self.addAnnotation(title: location,
                                                 coordinate: coordinate,
                                                 photoData: photoData)
                    }
                }
            }
        }
    }
    
    func addAnnotation(title: String, coordinate: CLLocationCoordinate2D, photoData: Data) {
        let annotation = SpotAnnotation(title: title, coordinate: coordinate, photoData: photoData)
        self.mapView.addAnnotation(annotation)
    }
    
    // MARK: - Functions: Polyline
    
    func drawJourneyListPolylines(with journeys: [Journey]) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                for journey in journeys {
                    group.addTask {
                        let coordinates = journey.coordinates.map {
                            CLLocationCoordinate2D(latitude: $0.latitude,
                                                   longitude: $0.longitude)
                        }
                        await self.drawPolyline(using: coordinates)
                    }
                }
            }
        }
    }
    
    func drawPolyline(using coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.addOverlay(polyline)
    }
    
    // MARK: - Functions
    
    public func clearAnnotations() {
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
    }
    
    public func clearOverlays() {
        let overlays = self.mapView.overlays
        self.mapView.removeOverlays(overlays)
    }
}

// MARK: - UI Configuration

private extension MapViewController {
    func configureLayout() {
        self.view = self.mapView
        self.mapView.layer.addSublayer(self.gradientLayer)
        
        self.view.addSubview(self.buttonStackView)
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                      constant: Metric.buttonStackTopSpacing),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -Metric.buttonStackTrailingSpacing)
        ])
    }
    
    func configureStyles() {
        if #available(iOS 17.0, *) {
            self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: Self, _) in
                self?.updateGradientColors()
            }
        }
    }
    
    private func updateGradientColors() {
        self.gradientLayer.gradientColors = [
            .msColor(.primaryBackground).withAlphaComponent(.zero),
            .msColor(.primaryBackground).withAlphaComponent(0.7)
        ]
    }
    
    private func configureCoreLocation() {
        self.locationManager.delegate = self
        switch self.locationManager.authorizationStatus {
        case .restricted, .denied:
            self.presentLocationAuthorizationAlert()
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
}

// MARK: - CLLocationManager

extension MapViewController: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task.detached {
            await self.handleAuthorizationChange(manager)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        guard self.timeRemaining == .zero,
              let newCurrentLocation = locations.last,
              let recordJourneyViewModel = self.viewModel as? RecordJourneyViewModel else {
            return
        }
        
        let coordinate2D = CLLocationCoordinate2D(latitude: newCurrentLocation.coordinate.latitude,
                                                  longitude: newCurrentLocation.coordinate.longitude)
        recordJourneyViewModel.trigger(.tenLocationsDidRecorded(coordinate2D))
    }
    
    private func handleAuthorizationChange(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            self.presentLocationAuthorizationAlert()
        case .authorizedAlways, .authorizedWhenInUse:
            self.checkAccuracyAuthorizationStatus(manager)
        @unknown default:
            MSLogger.make(category: .home).error("잘못된 위치 권한입니다.")
        }
    }
    
    /// 제공되는 위치 정보의 정확도에 따른 동작을 수행합니다.
    private func checkAccuracyAuthorizationStatus(_ manager: CLLocationManager) {
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            MSLogger.make(category: .home).log("위치 정보 정확도가 높습니다.")
        case .reducedAccuracy:
            MSLogger.make(category: .home).log("위치 정보 정확도가 낮습니다.")
        default:
            MSLogger.make(category: .home).error("잘못된 위치 정보 정확도에 대한 값입니다.")
        }
    }
    
    private func presentLocationAuthorizationAlert() {
        let sheet = UIAlertController(title: Typo.locationAlertTitle,
                                      message: Typo.locationAlertMessage,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Typo.locationAlertCancel, style: .cancel)
        let settingsAction = UIAlertAction(title: Typo.locationAlertSettings, style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(url)
        }
        sheet.addAction(cancelAction)
        sheet.addAction(settingsAction)
        DispatchQueue.main.async {
            self.present(sheet, animated: true)
        }
    }
}

// MARK: - MKMapView

extension MapViewController: MKMapViewDelegate {
    /// 현재까지의 polyline들을 지도 위에 그림
    public func mapView(_ mapView: MKMapView,
                        rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .msColor(.musicSpot)
        renderer.lineWidth = Metric.lineWidth
        renderer.alpha = 1.0
        
        return renderer
    }
    
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        if annotation is MKClusterAnnotation {
            return ClusterAnnotationView(annotation: annotation,
                                         reuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: SpotAnnotationView.identifier,
                                                                   for: annotation)
        return annotationView
    }
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.delegate?.mapViewControllerDidChangeVisibleRegion(self)
    }
}

// MARK: - ButtonView

extension MapViewController: ButtonStackViewDelegate {
    public func mapButtonDidTap() {
        MSLogger.make(category: .navigateMap).debug("현재 지도에서 보이는 범위 내의 모든 Spot들을 보여줍니다.")
    }
    
    public func userLocationButtonDidTap() {
        switch self.mapView.userTrackingMode {
        case .none, .followWithHeading:
            self.mapView.setUserTrackingMode(.follow, animated: true)
        case .follow:
            self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
        @unknown default: break
        }
    }
}