//
//  SplashViewController.swift
//  Launch
//
//  Created by 이창준 on 2024.02.14.
//

import UIKit

public final class SplashViewController: UIViewController {
    
    // MARK: - Constants
    
    public static let storyboardName = "SplashScreen"
    public static let storyboardID = "Splash"
    
    // MARK: - UI Components
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    // MARK: - Properties
    
    public let viewModel: SplashViewModel
    
    public weak var delegate: SplashNavigationDelegate?
    
    // MARK: - Initializer
    
    public init(viewModel: SplashViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init?(viewModel: SplashViewModel, coder: NSCoder) {
        self.viewModel = viewModel
        super.init(coder: coder)
        print("SplashVC initialized")
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = self.viewModel
        self.bind(viewModel)
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    // MARK: - Binding
    
    private func bind(_ viewModel: SplashViewModel) {
        
    }
    
}
