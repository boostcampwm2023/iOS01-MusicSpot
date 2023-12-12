//
//  SaveJourneyViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import CoreLocation
import MapKit
import MusicKit
import StoreKit
import SwiftUI
import UIKit

import MSDomain
import MSUIKit

public final class SaveJourneyViewController: UIViewController {
    
    typealias SaveJourneyDataSource = UICollectionViewDiffableDataSource<SaveJourneySection, SaveJourneyItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SaveJourneyHeaderView>
    typealias MusicCellRegistration = UICollectionView.CellRegistration<SaveJourneyMusicCell, Music>
    typealias SpotCellRegistration = UICollectionView.CellRegistration<SpotCell, Spot>
    typealias EmptyCellRegistration = UICollectionView.CellRegistration<EmptyCell, UUID>
    typealias SaveJourneySnapshot = NSDiffableDataSourceSnapshot<SaveJourneySection, SaveJourneyItem>
    typealias MusicSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    typealias SpotSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    typealias EmptySnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let nextButtonTitle = "다음"
        
    }
    
    private enum Metric {
        
        static let collectionViewBottomSpacing: CGFloat = 80.0
        static let buttonSpacing: CGFloat = 4.0
        static let buttonBottomInset: CGFloat = 24.0
        static let lineWidth: CGFloat = 0.5
        static let mapSpanAssistance: CGFloat = 1.2
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: SaveJourneyNavigationDelegate?
    
    let viewModel: SaveJourneyViewModel
    private(set) var dataSource: SaveJourneyDataSource?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let musicPlayer = ApplicationMusicPlayer.shared
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.clipsToBounds = true
        mapView.delegate = self
        return mapView
    }()
    
    var mapViewHeightConstraint: NSLayoutConstraint?
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.width,
                                                   left: .zero,
                                                   bottom: Metric.collectionViewBottomSpacing,
                                                   right: .zero)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.delegate = self
        return collectionView
    }()
    
    private let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.buttonSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let mediaControlButton: MSRectButton = {
        let button = MSRectButton.small()
        button.image = .msIcon(.play)
        return button
    }()
    
    private lazy var musicControlButton: UIHostingController = {
        let stateFactor = self.viewModel.state.buttonStateFactors.value
        let button = UIHostingController(rootView: MusicControlButton(stateFactor: stateFactor))
        return button
    }()
    
    private lazy var nextButton: MSButton = {
        let button = MSButton.primary()
        button.title = Typo.nextButtonTitle
        return button
    }()
    
    // MARK: - Initializer
    
    public init(viewModel: SaveJourneyViewModel,
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
        self.configureStyles()
        self.configureLayout()
        self.configureComponents()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.musicPlayer.pause()
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.selectedSong
            .receive(on: DispatchQueue.main)
            .sink { [weak self] song in
                guard let self = self else { return }
                
                self.musicControlButton.rootView.song = song
                Task {
                    self.musicPlayer.queue = ApplicationMusicPlayer.Queue(for: [song])
                    try await self.musicPlayer.prepareToPlay()
                }
                
                var snapshot = MusicSnapshot()
                let music = Music(song)
                snapshot.append([.music(music)])
                self.dataSource?.apply(snapshot, to: .music)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.buttonStateFactors
            .map { $0.isMusicPlaying }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isMusicPlaying in
                guard let self = self else { return }
                
                if isMusicPlaying, self.musicPlayer.isPreparedToPlay {
                    Task {
                        try await self.musicPlayer.play()
                    }
                } else {
                    self.musicPlayer.pause()
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.recordingJourney
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recordingJourney in
                guard let self = self else { return }
                
                let spots = recordingJourney.spots.compactMap { $0 }
                self.updateSpotSectionSnapshot(with: spots)
                self.updateMap(with: recordingJourney)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.endJourneySucceed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] endedJourney in
                self?.navigationDelegate?.popToHome(with: endedJourney)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    func setDataSource(_ dataSource: SaveJourneyDataSource) {
        self.dataSource = dataSource
    }
    
    private func updateSpotSectionSnapshot(with spots: [Spot]) {
        if spots.isEmpty {
            var emptySnapshot = EmptySnapshot()
            emptySnapshot.append([.empty])
            self.dataSource?.apply(emptySnapshot, to: .empty)
        } else {
            var spotSnapshot = SpotSnapshot()
            spotSnapshot.append(spots.map { .spot($0) })
            self.dataSource?.apply(spotSnapshot, to: .spot)
        }
    }
    
    // MARK: - Functions: Polyline
    
    private func updateMap(with recordingJourney: RecordingJourney) {
        self.drawPolyLinesToMap(with: recordingJourney)
        guard let region = self.focusToJourney(from: recordingJourney.coordinates) else {
            return
        }
        self.mapView.setRegion(region, animated: true)
    }
    
    private func drawPolyLinesToMap(with journey: RecordingJourney) {
        Task {
            let coordinates = journey.coordinates.map {
                CLLocationCoordinate2D(latitude: $0.latitude,
                                       longitude: $0.longitude)
            }
            self.drawPolylineToMap(using: coordinates)
        }
    }
    
    private func drawPolylineToMap(using coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates,
                                  count: coordinates.count)
        self.mapView.addOverlay(polyline)
    }
    
    func focusToJourney(from coordinates: [Coordinate]) -> MKCoordinateRegion? {
        guard !coordinates.isEmpty else { return nil }
        
        let (minLat, maxLat, minLon, maxLon) = coordinates.reduce((coordinates[0].latitude,
                                                                   coordinates[0].latitude,
                                                                   coordinates[0].longitude,
                                                                   coordinates[0].longitude)) { result, coordinate in
            (min(result.0, coordinate.latitude),
             max(result.1, coordinate.latitude),
             min(result.2, coordinate.longitude),
             max(result.3, coordinate.longitude))
        }
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLon + maxLon) / 2)
        
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * Metric.mapSpanAssistance,
                                    longitudeDelta: (maxLon - minLon) * Metric.mapSpanAssistance)
        
        return MKCoordinateRegion(center: center, span: span)
    }
    
}

extension SaveJourneyViewController: MKMapViewDelegate {
    
    public func mapView(_ mapView: MKMapView,
                        rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }
        
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .msColor(.musicSpot)
        renderer.lineWidth = Metric.lineWidth
        renderer.alpha = 1.0
        
        return renderer
    }
    
}

// MARK: - Buttons

private extension SaveJourneyViewController {
    
    func configureButtons() {
        self.musicControlButton.rootView.musicControlAction = { [weak self] in
            self?.viewModel.trigger(.musicControlButtonDidTap)
        }
        
        let nextButtonAction = UIAction { [weak self] _ in
            self?.presentSaveJourney()
        }
        self.nextButton.addAction(nextButtonAction, for: .touchUpInside)
    }
    
}

// MARK: - AlertViewController

extension SaveJourneyViewController: AlertViewControllerDelegate {
    
    private func presentSaveJourney() {
        let alert = ConfirmTitleAlertViewController()
        alert.modalPresentationStyle = .overCurrentContext
        alert.delegate = self
        self.present(alert, animated: false)
    }
    
    func titleDidConfirmed(_ title: String) {
        self.viewModel.trigger(.titleDidConfirmed(title))
    }
    
}

// MARK: - UI Configuration

private extension SaveJourneyViewController {
    
    func configureStyles() {
        self.view.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        self.view.addSubview(self.mapView)
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.mapViewHeightConstraint = self.mapView.heightAnchor.constraint(equalTo: self.mapView.widthAnchor)
        self.mapViewHeightConstraint?.isActive = true
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        self.view.addSubview(self.buttonStack)
        self.buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buttonStack.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            self.buttonStack.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            self.buttonStack.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor,
                                                     constant: -Metric.buttonBottomInset)
        ])
        
        guard let musicControlButton = self.musicControlButton.view else { return }
        self.addChild(self.musicControlButton)
        self.view.addSubview(musicControlButton)
        [
            musicControlButton,
            self.nextButton
        ].forEach {
            self.buttonStack.addArrangedSubview($0)
        }
        self.musicControlButton.didMove(toParent: self)
        NSLayoutConstraint.activate([
            self.musicControlButton.view.widthAnchor.constraint(equalToConstant: 52.0),
            self.musicControlButton.view.heightAnchor.constraint(equalTo: self.nextButton.heightAnchor)
        ])
    }
    
    func configureComponents() {
        self.configureCollectionView()
        self.configureButtons()
    }
    
}
