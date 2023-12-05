//
//  HomeBottomSheetViewController.swift
//  Home
//
//  Created by 이창준 on 2023.12.01.
//

import UIKit

import JourneyList
import MSConstants
import MSUIKit
import MSUserDefaults
import NavigateMap

public typealias HomeBottomSheetViewController = MSBottomSheetViewController<NavigateMapViewController, JourneyListViewController>

public final class HomeViewController: HomeBottomSheetViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let startButtonTitle = "시작하기"
        
    }
    
    private enum Metric {
        
        static let startButtonBottomInset: CGFloat = 16.0
        
    }
    
    // MARK: - UI Components
    
    private let startButton: MSButton = {
        let button = MSButton.primary()
        button.cornerStyle = .rounded
        button.title = Typo.startButtonTitle
        return button
    }()
    
    private lazy var recordJourneyButtonView: RecordJourneyButtonView = {
        let buttonView = RecordJourneyButtonView()
        buttonView.delegate = self
        buttonView.isHidden = true
        return buttonView
    }()
    
    // MARK: - Properties
    
    public weak var navigationDelegate: HomeNavigationDelegate?
    
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    private var isRecording: Bool
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.contentViewController.delegate = self
        self.configureStyle()
        self.configureLayout()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Functions
    
    private func updateButtonMode() {
        self.startButton.isHidden = self.isRecording
        self.recordJourneyButtonView.isHidden = !self.isRecording
    }
    
    @objc
    func startButtonDidTap() {
        self.isRecording.toggle()
        self.updateButtonMode()
    }
    
}

// MARK: - UI Configuration

private extension HomeViewController {
    
    func configureStyle() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
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
    }
    
}

extension HomeViewController: NavigateMapViewControllerDelegate {
    
    public func settingButtonDidTap() {
        // 
    }
    
    public func mapButtonDidTap() {
        print(#function)
    }
    
    public func locationButtonDidTap() {
        print(#function)
    }
    
}

// MARK: - Button View

extension HomeViewController: RecordJourneyButtonViewDelegate {
    
    public func backButtonDidTap(_ button: MSRectButton) {
        print("뒤로가기 버튼 클릭")
    }
    
    public func spotButtonDidTap(_ button: MSRectButton) {
        self.navigationDelegate?.navigateToSpot()
    }
    
    public func nextButtonDidTap(_ button: MSRectButton) {
        self.navigationDelegate?.navigateToSelectSong()
    }
    
}
