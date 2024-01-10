//
//  HomeBottomSheetViewController.swift
//  Home
//
//  Created by 이창준 on 2023.12.01.
//

import ActivityKit
import Combine
import UIKit

import JourneyList
import MSConstants
import MSDesignSystem
import MSDomain
import MSUIKit
import MSUserDefaults
import NavigateMap

public typealias HomeBottomSheetViewController
= MSBottomSheetViewController<MapViewController, JourneyListViewController>

public final class HomeViewController: HomeBottomSheetViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let startButtonTitle = "시작하기"
        static let refreshButtonTitle = "여기서 다시 검색"
        
    }
    
    private enum Metric {
        
        static let startButtonBottomInset: CGFloat = 16.0
        static let recordJourneyButtonBottomInset: CGFloat = 50.0
        
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
    
    private lazy var recordJourneyButtonStackView: RecordJourneyButtonStackView = {
        let buttonView = RecordJourneyButtonStackView()
        buttonView.delegate = self
        buttonView.isHidden = true
        return buttonView
    }()
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    public weak var navigationDelegate: HomeNavigationDelegate?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializer
    
    public init(viewModel: HomeViewModel,
                contentViewController: MapViewController,
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
        
        self.configureLayout()
        self.configureAction()
        self.bind()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 화면 시작 시 새로고침 버튼 기능 한번 실행
        self.refreshButton.sendActions(for: .touchUpInside)
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.journeyDidStarted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] startedJourney in
                self?.contentViewController.clearOverlays()
                self?.contentViewController.recordingDidStart(startedJourney)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.journeyDidResumed
            .receive(on: DispatchQueue.main)
            .sink { [weak self] resumedJourney in
                self?.contentViewController.clearOverlays()
                self?.contentViewController.recordingDidResume(resumedJourney)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.journeyDidCancelled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cancelledJourney in
                self?.contentViewController.clearOverlays()
                self?.contentViewController.recordingDidStop(cancelledJourney)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.visibleJourneys
            .sink { [weak self] visibleJourneys in
                self?.contentViewController.visibleJourneysDidUpdated(visibleJourneys)
                self?.bottomSheetViewController.visibleJourneysDidUpdated(visibleJourneys)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.isRecording
            .removeDuplicates()
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                if isRecording {
                    self?.hideBottomSheet()
                } else {
                    self?.showBottomSheet()
                }
                self?.updateButtonMode(isRecording: isRecording)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.isStartButtonLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isStartButtonLoading in
                self?.startButton.configuration?.showsActivityIndicator = isStartButtonLoading
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.isRefreshButtonHidden
            .combineLatest(self.viewModel.state.isRecording)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isHidden, isRecording in
                guard let self = self else { return }
                UIView.transition(with: self.refreshButton,
                                  duration: 0.2,
                                  options: .transitionCrossDissolve) { [weak self] in
                    self?.refreshButton.isHidden = (isHidden || isRecording)
                }
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    private func updateButtonMode(isRecording: Bool) {
        UIView.transition(with: self.view,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            self?.startButton.isHidden = isRecording
            self?.recordJourneyButtonStackView.isHidden = !isRecording
        })
    }
    
}

// MARK: - Buttons

extension HomeViewController: RecordJourneyButtonViewDelegate {
    
    private func configureAction() {
        let startButtonAction = UIAction { [weak self] _ in
            self?.startButtonDidTap()
        }
        self.startButton.addAction(startButtonAction, for: .touchUpInside)
        
        let refreshButtonAction = UIAction { [weak self] _ in
            self?.refreshButtonDidTap()
        }
        self.refreshButton.addAction(refreshButtonAction, for: .touchUpInside)
    }
    
    private func startButtonDidTap() {
        guard let userLocation = self.contentViewController.userLocation else { return }
        
        let coordinate = Coordinate(latitude: userLocation.coordinate.latitude,
                                    longitude: userLocation.coordinate.longitude)
        self.viewModel.trigger(.startButtonDidTap(coordinate))
    }
    
    private func refreshButtonDidTap() {
        let coordinates = self.contentViewController.visibleCoordinates
        self.viewModel.trigger(.refreshButtonDidTap(visibleCoordinates: coordinates))
    }
    
    public func backButtonDidTap(_ button: MSRectButton) {
        guard self.viewModel.state.isRecording.value == true else { return }
        
        self.viewModel.trigger(.backButtonDidTap)
    }
    
    public func spotButtonDidTap(_ button: MSRectButton) {
        guard self.viewModel.state.isRecording.value == true else { return }
        
        guard let currentUserCoordiante = self.contentViewController.currentUserCoordinate else {
            return
        }
        
        self.navigationDelegate?.navigateToSpot(spotCoordinate: currentUserCoordiante)
    }
    
    public func nextButtonDidTap(_ button: MSRectButton) {
        guard self.viewModel.state.isRecording.value == true else { return }
        
        guard let currentUserCoordiante = self.contentViewController.currentUserCoordinate else {
            return
        }
        
        self.navigationDelegate?.navigateToSelectSong(lastCoordinate: currentUserCoordiante)
    }
    
}

// MARK: - MapViewController

extension HomeViewController: MapViewControllerDelegate {
    
    public func mapViewControllerDidChangeVisibleRegion(_ mapViewController: MapViewController) {
        self.viewModel.trigger(.mapViewDidChange)
    }
    
}

// MARK: - UI Configuration

private extension HomeViewController {
    
    func configureLayout() {
        let bottomSheetTopAnchor = self.bottomSheetViewController.view.topAnchor
        
        self.view.addSubview(self.startButton)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: bottomSheetTopAnchor,
                                                     constant: -Metric.startButtonBottomInset)
        ])
        
        self.view.addSubview(self.recordJourneyButtonStackView)
        self.recordJourneyButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        let safeAreaBottomAnchor = self.view.safeAreaLayoutGuide.bottomAnchor
        NSLayoutConstraint.activate([
            self.recordJourneyButtonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.recordJourneyButtonStackView.bottomAnchor.constraint(equalTo: safeAreaBottomAnchor,
                                                                      constant: -Metric.recordJourneyButtonBottomInset)
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
