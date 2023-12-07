//
//  HomeBottomSheetViewController.swift
//  Home
//
//  Created by 이창준 on 2023.12.01.
//

import Combine
import UIKit

import JourneyList
import MSConstants
import MSDesignSystem
import MSDomain
import MSUIKit
import MSUserDefaults
import NavigateMap

public typealias HomeBottomSheetViewController = MSBottomSheetViewController<NavigateMapViewController, JourneyListViewController>

public final class HomeViewController: HomeBottomSheetViewController, HomeViewModelDelegate {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let startButtonTitle = "시작하기"
        static let refreshButtonTitle = "여기서 다시 검색"
        
    }
    
    private enum Metric {
        
        static let startButtonBottomInset: CGFloat = 16.0
        
        enum RefreshButton {
            
            static let topSpacing: CGFloat = 80.0
            static let horizontalEdgeInsets: CGFloat = 24.0
            static let verticalEdgeInsets: CGFloat = 10.0
            
        }
        
    }
    
    // MARK: - UI Components
    
    private let startButton: MSButton = {
        let button = MSButton.primary()
        button.cornerStyle = .rounded
        button.title = Typo.startButtonTitle
        return button
    }()
    
    private let refreshButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        var container = AttributeContainer()
        container.font = .msFont(.boldCaption)
        configuration.attributedTitle = AttributedString(Typo.refreshButtonTitle, attributes: container)
        configuration.contentInsets = NSDirectionalEdgeInsets(top: Metric.RefreshButton.verticalEdgeInsets,
                                                              leading: Metric.RefreshButton.horizontalEdgeInsets,
                                                              bottom: Metric.RefreshButton.verticalEdgeInsets,
                                                              trailing: Metric.RefreshButton.horizontalEdgeInsets)
        configuration.baseBackgroundColor = .msColor(.secondaryButtonBackground).withAlphaComponent(0.8)
        configuration.baseForegroundColor = .msColor(.secondaryButtonTypo)
        configuration.cornerStyle = .capsule
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var recordJourneyButtonView: RecordJourneyButtonView = {
        let buttonView = RecordJourneyButtonView()
        buttonView.delegate = self
        buttonView.isHidden = true
        return buttonView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    public weak var navigationDelegate: HomeNavigationDelegate?
    
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    private var isRecording: Bool
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    
    public init(viewModel: HomeViewModel,
                contentViewController: NavigateMapViewController,
                bottomSheetViewController: JourneyListViewController) {
        self.viewModel = viewModel
        super.init(contentViewController: contentViewController,
                   bottomSheetViewController: bottomSheetViewController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyle()
        self.configureLayout()
        self.configureAction()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.journeys
            .receive(on: DispatchQueue.main)
            .sink { journeys in
                self.contentViewController.addAnnotations(journeys: journeys)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    private func updateButtonMode() {
        UIView.transition(with: startButton, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.startButton.isHidden = self.isRecording
                      })
        UIView.transition(with: recordJourneyButtonView, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.recordJourneyButtonView.isHidden = !self.isRecording
                      })
        if self.startButton.isHidden {
            setUserLocationToCenter()
        }
    }
    
    private func setUserLocationToCenter() {
        
    }
    
    private func configureAction() {
        let startButtonAction = UIAction { [weak self] _ in
            self?.isRecording.toggle()
            self?.updateButtonMode()
        }
        self.startButton.addAction(startButtonAction, for: .touchUpInside)
        
        let refreshButtonAction = UIAction { [weak self] _ in
            guard let coordinates = self?.contentViewController.currentCoordinate else {
                return
            }
            self?.viewModel.trigger(.fetchJourney(at: coordinates))
        }
        self.refreshButton.addAction(refreshButtonAction, for: .touchUpInside)
    }
    
    public func fetchJourneys(from coordinates: (Coordinate, Coordinate)) {
        self.viewModel.trigger(.fetchJourney(at: coordinates))
    }
    
//    public func fetchUserID() {
//        self.viewModel.
//    }
    
    @objc
    func startButtonDidTap() {
        self.isRecording.toggle()
        self.updateButtonMode()
    }
}

// MARK: - Button View

extension HomeViewController: RecordJourneyButtonViewDelegate {
    
    public func backButtonDidTap(_ button: MSRectButton) {
        self.startButtonDidTap()
    }
    
    public func spotButtonDidTap(_ button: MSRectButton) {
        self.navigationDelegate?.navigateToSpot()
    }
    
    public func nextButtonDidTap(_ button: MSRectButton) {
        guard let userLocation = self.contentViewController.userLocation else { return }
        print(userLocation)
        
        let lastCoordinate = Coordinate(latitude: userLocation.coordinate.latitude,
                                        longitude: userLocation.coordinate.longitude)
        // TODO: 기록중인 여정 fetch
        let recordingJourney = RecordingJourney(id: "6571bef418be25527c66dc04",
                                                startTimestamp: .now,
                                                spots: [],
                                                coordinates: [])
        self.navigationDelegate?.navigateToSelectSong(recordingJourney: recordingJourney,
                                                      lastCoordinate: lastCoordinate)
    }
    
}

// MARK: - UI Configuration

private extension HomeViewController {
    
    func configureStyle() {
        
    }
    
    func configureLayout() {
        self.view.addSubview(self.startButton)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.bottomSheetViewController.view.topAnchor,
                                                     constant: -Metric.startButtonBottomInset)
        ])
        
        self.view.addSubview(self.recordJourneyButtonView)
        self.recordJourneyButtonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.recordJourneyButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordJourneyButtonView.bottomAnchor.constraint(equalTo: self.bottomSheetViewController.view.topAnchor,
                                                                 constant: -Metric.startButtonBottomInset)
        ])
        
        self.view.insertSubview(self.refreshButton, belowSubview: self.bottomSheetViewController.view)
        self.refreshButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.refreshButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                    constant: Metric.RefreshButton.topSpacing),
            self.refreshButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
}
