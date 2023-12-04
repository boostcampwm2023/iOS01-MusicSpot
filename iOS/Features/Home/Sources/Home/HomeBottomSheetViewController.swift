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

public protocol HomeViewControllerDelegate: AnyObject {
    
    func navigateToSpot()
    func navigateToRewind()
    func navigateToSetting()
    
}

public typealias HomeViewController = MSBottomSheetViewController<NavigateMapViewController, JourneyListViewController>

public final class HomeBottomSheetViewController: HomeViewController {
    
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
    
    public weak var delegate: HomeViewControllerDelegate?
    
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
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLayout()
    
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

private extension HomeBottomSheetViewController {
    
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

extension HomeBottomSheetViewController: NavigateMapViewControllerDelegate {
    
    public func settingButtonDidTap() {
        delegate?.navigateToSetting()
    }
    
    public func mapButtonDidTap() {
        print(#function)
    }
    
    public func locationButtonDidTap() {
        print(#function)
    }
    
}

// MARK: - Button View

extension HomeBottomSheetViewController: RecordJourneyButtonViewDelegate {
    
    public func backButtonDidTap(_ button: MSRectButton) {
        print("뒤로가기 버튼 클릭")
    }
    
    public func spotButtonDidTap(_ button: MSRectButton) {
        print("spot 버튼 클릭")
    }
    
    public func nextButtonDidTap(_ button: MSRectButton) {
        print("체크 버튼 클릭")
    }
    
}
