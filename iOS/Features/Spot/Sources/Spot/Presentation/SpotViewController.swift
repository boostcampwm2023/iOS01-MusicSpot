//
//  SpotViewController.swift
//  Spot
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSData
import MSDesignSystem
import MSDomain
import MSLogger
import MSUIKit

public final class SpotViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Constants
    
    private enum Metric {
        
        // Camera View
        enum CameraView {
            static let bottomInset: CGFloat = 50.0
        }
        
        // Shot Button
        enum ShotButton {
            static let height: CGFloat = 70.0
            static let width: CGFloat = 70.0
            static let bottomInset: CGFloat = 60.0
            static let radius: CGFloat = ShotButton.width / 2
            static let borderWidth: CGFloat = 5.0
        }
        
        // Gallery Button
        enum GalleryButton {
            static let height: CGFloat = 35.0
            static let width: CGFloat = 35.0
            static let bottomInset: CGFloat = .zero
            static let leadingInset: CGFloat = 30.0
            static let radius: CGFloat = 6.0
        }
        
        // Swap Button
        enum SwapButton {
            static let height: CGFloat = 35.0
            static let width: CGFloat = 35.0
            static let bottomInset: CGFloat = .zero
            static let trailingInset: CGFloat = 30.0
            static let radius: CGFloat = SwapButton.width / 2
        }
        
        // Back Button
        enum BackButton {
            static let height: CGFloat = 35.0
            static let width: CGFloat = 35.0
            static let inset: CGFloat = 10.0
        }
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: SpotNavigationDelegate?
    private let viewModel: SpotViewModel
    
    // MARK: - Properties: Gesture
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    // MARK: - Properties: Haptic
    
    private let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    // MARK: - UI Components
    
    private let backButton = UIButton()
    private let cameraView = CameraView()
    private let shotButton = UIButton()
    private let galleryButton = UIButton()
    private let swapButton = UIButton()
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        self.haptic.prepare()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.startCamera()
    }
    
    // MARK: - Initializer
    
    public init(viewModel: SpotViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Configuration
    
    private func configure() {
        self.configureLayout()
        self.configureStyles()
        self.configureAction()
        self.configureDelegate()
    }
    
}

// MARK: - UI Configuration: Layout

private extension SpotViewController {
    
    func configureLayout() {
        [
            self.cameraView,
            self.shotButton,
            self.galleryButton,
            self.swapButton,
            self.backButton
        ].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.configureNavigationBarBackgroundViewLayout()
        self.configureCameraViewLayout()
        self.configureShotButtonLayout()
        self.configureGalleryButtonLayout()
        self.configureSwapButtonLayout()
    }
    
    func configureNavigationBarBackgroundViewLayout() {
        NSLayoutConstraint.activate([
            self.backButton.heightAnchor.constraint(equalToConstant: Metric.BackButton.height),
            self.backButton.widthAnchor.constraint(equalToConstant: Metric.BackButton.width),
            
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Metric.BackButton.inset),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                     constant: Metric.BackButton.inset)
        ])
    }
    
    func configureCameraViewLayout() {
        NSLayoutConstraint.activate([
            self.cameraView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.cameraView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.cameraView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Metric.CameraView.bottomInset),
            self.cameraView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func configureShotButtonLayout() {
        NSLayoutConstraint.activate([
            self.shotButton.heightAnchor.constraint(equalToConstant: Metric.ShotButton.height),
            self.shotButton.widthAnchor.constraint(equalToConstant: Metric.ShotButton.width),
            
            self.shotButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.shotButton.centerYAnchor.constraint(equalTo: self.cameraView.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -Metric.ShotButton.bottomInset)
        ])
    }
    
    func configureGalleryButtonLayout() {
        NSLayoutConstraint.activate([
            self.galleryButton.heightAnchor.constraint(equalToConstant: Metric.GalleryButton.height),
            self.galleryButton.widthAnchor.constraint(equalToConstant: Metric.GalleryButton.width),
            
            self.galleryButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor,
                                                        constant: Metric.GalleryButton.leadingInset),
            self.galleryButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                       constant: -Metric.GalleryButton.bottomInset)
        ])
    }
    
    func configureSwapButtonLayout() {
        NSLayoutConstraint.activate([
            self.swapButton.heightAnchor.constraint(equalToConstant: Metric.SwapButton.height),
            self.swapButton.widthAnchor.constraint(equalToConstant: Metric.SwapButton.width),
            
            self.swapButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -Metric.SwapButton.trailingInset),
            self.swapButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Metric.SwapButton.bottomInset)
        ])
    }
    
}
    
    // MARK: UI Configuration: Style
    
private extension SpotViewController {
    
    func configureStyles() {
        self.view.backgroundColor = .black
        
        var shotButtonConfiguration = UIButton.Configuration.filled()
        shotButtonConfiguration.baseBackgroundColor = .msColor(.componentBackground)
        self.shotButton.configuration = shotButtonConfiguration
        self.shotButton.layer.cornerRadius = Metric.ShotButton.radius
        self.shotButton.layer.borderColor = UIColor.msColor(.musicSpot).cgColor
        self.shotButton.layer.borderWidth = Metric.ShotButton.borderWidth
        self.shotButton.clipsToBounds = true
        
        var galleryButtonConfiguration = UIButton.Configuration.filled()
        galleryButtonConfiguration.baseBackgroundColor = .darkGray
        galleryButtonConfiguration.baseForegroundColor = .white
        galleryButtonConfiguration.image = UIImage(systemName: "photo.fill")
        self.galleryButton.configuration = galleryButtonConfiguration
        self.galleryButton.layer.cornerRadius = Metric.GalleryButton.radius
        self.galleryButton.clipsToBounds = true
        
        var swapButtonConfiguration = UIButton.Configuration.filled()
        swapButtonConfiguration.baseBackgroundColor = .darkGray
        swapButtonConfiguration.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        swapButtonConfiguration.baseForegroundColor = .white
        self.swapButton.configuration = swapButtonConfiguration
        self.swapButton.layer.cornerRadius = Metric.SwapButton.radius
        self.swapButton.clipsToBounds = true
        
        var backButtonConfiguration = UIButton.Configuration.filled()
        backButtonConfiguration.baseBackgroundColor = .darkGray
        backButtonConfiguration.baseForegroundColor = .white
        backButtonConfiguration.image = UIImage(systemName: "xmark")
        self.backButton.configuration = backButtonConfiguration
        self.backButton.alpha = 0.5
        self.backButton.layer.cornerRadius = Metric.SwapButton.radius
        self.backButton.clipsToBounds = true
    }
    
}

// MARK: - Configuration: Actions

private extension SpotViewController {
    
    func configureAction() {
        self.configureCameraSetting()
        self.configureShotButtonAction()
        self.configureSwapButtonAction()
        self.configureBackButtonAction()
        self.configureGalleryButtonAction()
        
        self.configureLeftToRightSwipeGesture()
    }
    
    func configureCameraSetting() {
        self.viewModel.preset(screen: self.cameraView)
    }
    
    func configureShotButtonAction() {
        let shotButtonAction = UIAction { [weak self] _ in
            self?.shotButtonTapped()
        }
        self.shotButton.addAction(shotButtonAction, for: .touchUpInside)
    }
    
    func configureSwapButtonAction() {
        let swapButtonAction = UIAction { [weak self] _ in
            self?.swapButtonTapped()
        }
        self.swapButton.addAction(swapButtonAction, for: .touchUpInside)
    }
    
    func configureGalleryButtonAction() {
        let galleryButtonAction = UIAction { [weak self] _ in
            self?.galleryButtonTapped()
        }
        self.galleryButton.addAction(galleryButtonAction, for: .touchUpInside)
    }
    
    func configureBackButtonAction() {
        let backButtonAction = UIAction { [weak self] _ in
            self?.backButtonTapped()
        }
        self.backButton.addAction(backButtonAction, for: .touchUpInside)
    }
    
}

// MARK: - Button Actions

private extension SpotViewController {
    
    func shotButtonTapped() {
        self.viewModel.shot()
        self.haptic.impactOccurred()
    }
    
    func swapButtonTapped() {
        self.viewModel.swap()
    }
    
    func galleryButtonTapped() {
        self.navigationDelegate?.presentPhotoLibrary(from: self)
    }
    
    func backButtonTapped() {
        self.navigationDelegate?.popToHome()
    }
    
}

// MARK: - Configuration: Delegate
    
private extension SpotViewController {
    
    func configureDelegate() {
        self.viewModel.delegate = self
    }
    
}

// MARK: - Delegate: ShotDelegate

extension SpotViewController: ShotDelegate {
    
    func update(imageData: Data?) {
        guard let imageData, let image = UIImage(data: imageData) else {
            MSLogger.make(category: .camera).error("촬영된 image가 저장되지 않았습니다.")
            return
        }
        
        self.cameraView.layer.contents = imageData
        self.presentSpotSaveViewController(with: image, coordinate: self.viewModel.coordinate)
    }
    
}

// MARK: - Delegate: ImagePickerDelegate

extension SpotViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.presentSpotSaveViewController(with: image, coordinate: self.viewModel.coordinate)
    }
    
}

// MARK: - Functions

private extension SpotViewController {
    
    func presentSpotSaveViewController(with image: UIImage, coordinate: Coordinate) {
        self.viewModel.stopCamera()
        self.navigationDelegate?.presentSaveSpot(using: image, coordinate: coordinate)
    }
    
}
