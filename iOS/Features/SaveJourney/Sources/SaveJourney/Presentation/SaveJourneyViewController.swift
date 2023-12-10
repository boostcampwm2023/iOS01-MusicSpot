//
//  SaveJourneyViewController.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import Combine
import CoreLocation
import MapKit
import MediaPlayer
import MusicKit
import UIKit

import MSDomain
import MSUIKit

public final class SaveJourneyViewController: UIViewController {
    
    typealias SaveJourneyDataSource = UICollectionViewDiffableDataSource<SaveJourneySection, SaveJourneyItem>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<SaveJourneyHeaderView>
    typealias MusicCellRegistration = UICollectionView.CellRegistration<SaveJourneyMusicCell, Music>
    typealias SpotCellRegistration = UICollectionView.CellRegistration<SpotCell, Spot>
    typealias SaveJourneySnapshot = NSDiffableDataSourceSnapshot<SaveJourneySection, SaveJourneyItem>
    typealias MusicSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    typealias SpotSnapshot = NSDiffableDataSourceSectionSnapshot<SaveJourneyItem>
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let nextButtonTitle = "다음"
        
    }
    
    private enum Metric {
        
        static let collectionViewBottomSpacing: CGFloat = 80.0
        static let buttonSpacing: CGFloat = 4.0
        static let buttonBottomInset: CGFloat = 24.0
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: SaveJourneyNavigationDelegate?
    
    let viewModel: SaveJourneyViewModel
    private(set) var dataSource: SaveJourneyDataSource?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let musicPlayer = MPMusicPlayerApplicationController.applicationMusicPlayer
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        return mapView
    }()
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: UICollectionViewLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: self.view.frame.width,
                                                   left: .zero,
                                                   bottom: Metric.collectionViewBottomSpacing,
                                                   right: .zero)
        collectionView.delegate = self
        return collectionView
    }()
    
    private(set) var mapViewHeightConstraint: NSLayoutConstraint?
    
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
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.selectedSong
            .combineLatest(self.viewModel.state.mediaItem)
            .compactMap { (song, mediaQuery) -> (Song, MPMediaQuery)? in
                guard let mediaQuery = mediaQuery else { return nil }
                return (song, mediaQuery)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] song, mediaQuery in
                guard let self = self else { return }
                var snapshot = MusicSnapshot()
                snapshot.append([.music(Music(song))])
                self.dataSource?.apply(snapshot, to: .music)
                
                Task {
                    self.musicPlayer.setQueue(with: mediaQuery)
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.recordingJourney
            .compactMap { $0?.spots }
            .receive(on: DispatchQueue.main)
            .sink { spots in
                var snapshot = SpotSnapshot()
                snapshot.append(spots.map { .spot($0) })
                self.dataSource?.apply(snapshot, to: .spot)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.isMusicPlaying
            .receive(on: DispatchQueue.main)
            .sink { isMusicPlaying in
                self.mediaControlButton.image = isMusicPlaying ? .msIcon(.pause) : .msIcon(.play)
                if isMusicPlaying {
                    self.musicPlayer.play()
                } else {
                    self.musicPlayer.pause()
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.endJourneyResponse
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.navigationDelegate?.popToHome()
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    func updateDataSource(_ dataSource: SaveJourneyDataSource) {
        self.dataSource = dataSource
    }
    
}

// MARK: - Buttons

private extension SaveJourneyViewController {
    
    func configureButtons() {
        let mediaControlAction = UIAction { [weak self] _ in
            self?.viewModel.trigger(.mediaControlButtonDidTap)
        }
        self.mediaControlButton.addAction(mediaControlAction, for: .touchUpInside)
        
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
        
        [
            self.mediaControlButton,
            self.nextButton
        ].forEach {
            self.buttonStack.addArrangedSubview($0)
        }
    }
    
    func configureComponents() {
        self.configureCollectionView()
        self.configureButtons()
    }
    
}
