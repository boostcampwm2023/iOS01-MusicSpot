//
//  HomeBottomSheetViewController.swift
//  Home
//
//  Created by 이창준 on 2023.12.01.
//

import UIKit

import JourneyList
import MSUIKit
import NavigateMap

public protocol HomeViewControllerDelegate: AnyObject {
    
    func navigateToSpot()
    func navigateToRewind()
    func navigateToSetting()
    
}

public typealias HomeViewController = MSBottomSheetViewController<NavigateMapViewController, JourneyListViewController>

public final class HomeBottomSheetViewController: HomeViewController, NavigationViewControllerDelegate {
    public func navigateToSetting() {
        delegate?.navigateToSetting()
    }
    
    public func showUserLocation() {
        print(#function)
    }
    
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
        button.tag = 100
        return button
    }()
    
    private let spotButtonView: RecordJourneyButtonView = {
        let buttonView = RecordJourneyButtonView()
        return buttonView
    }()
    
    // MARK: - Properties
    
    public weak var delegate: HomeViewControllerDelegate?
    
    public var isRecording: Bool = false
    
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
        startButton.isHidden = isRecording
        spotButtonView.isHidden = !isRecording
    }
    
    @objc
    func startButtonDidTap() {
        isRecording.toggle()
        updateButtonMode()
    }
    
    @objc
    func spotButtonDidTap() {
        print(#function)
    }
    
    @objc
    func nextButtonDidTap() {
        print(#function)
    }
    
}

// MARK: - UI Configuration

private extension HomeBottomSheetViewController {
    
    func configureStyle() {
        self.startButton.addTarget(self, action: #selector(startButtonDidTap), for: .touchUpInside)
        self.spotButtonView.stackButtonView.backButton.addTarget(self,
                                                                 action: #selector(startButtonDidTap),
                                                                 for: .touchUpInside)
        self.spotButtonView.stackButtonView.spotButton.addTarget(self,
                                                                 action: #selector(spotButtonDidTap),
                                                                 for: .touchUpInside)
        self.spotButtonView.stackButtonView.nextButton.addTarget(self,
                                                                 action: #selector(nextButtonDidTap),
                                                                 for: .touchUpInside)
    }
    
    func configureLayout() {
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.spotButtonView)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.spotButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.spotButtonView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.spotButtonView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                        constant: -20)
        ])
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.bottomSheetViewController.view.topAnchor,
                                                     constant: -Metric.startButtonBottomInset)
        ])
        
        updateButtonMode()
    }
    
}
