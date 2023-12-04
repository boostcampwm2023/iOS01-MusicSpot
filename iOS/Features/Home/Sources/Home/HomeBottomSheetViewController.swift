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
    
    // MARK: - Properties
    
    public weak var delegate: HomeViewControllerDelegate?
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureLayout()
    }
    
}

// MARK: - UI Configuration

private extension HomeBottomSheetViewController {
    
    func configureLayout() {
        self.view.addSubview(self.startButton)
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.startButton.bottomAnchor.constraint(equalTo: self.bottomSheetViewController.view.topAnchor,
                                                     constant: -Metric.startButtonBottomInset)
        ])
    }
    
}
