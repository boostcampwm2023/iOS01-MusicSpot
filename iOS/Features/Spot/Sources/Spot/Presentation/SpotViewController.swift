//
//  SpotViewController.swift
//  Spot
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSData
import MSDesignSystem
import MSLogger
import MSNetworking
import MSUIKit

public final class SpotViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Constants
    
    private enum Metric {
        
        // camera view
        enum CameraView {
            static let bottomInset: CGFloat = 50.0
        }
        
        // shot button
        enum ShotButton {
            static let height: CGFloat = 70.0
            static let width: CGFloat = 70.0
            static let bottomInset: CGFloat = 60.0
            static let radius = width / 2
            static let borderWidth: CGFloat = 5.0
        }
        
        // gallery button
        enum GalleryButton {
            static let height: CGFloat = 35.0
            static let width: CGFloat = 35.0
            static let bottomInset: CGFloat = 0.0
            static let leadingInset: CGFloat = 30.0
            static let radius: CGFloat = 6.0
        }
        
        // gallery button
        enum SwapButton {
            static let height: CGFloat = 35.0
            static let width: CGFloat = 35.0
            static let bottomInset: CGFloat = 0.0
            static let trailingInset: CGFloat = 30.0
            static let radius: CGFloat = width / 2
        }
    }
    
    // MARK: - Properties
    
    private let spotViewModel = SpotViewModel()
    private let spotSaveViewController = SpotSaveViewController()
    private let picker = UIImagePickerController()
    
    // MARK: - Properties: Networking
    
    internal var spotRouter: Router? {
        didSet {
            self.spotSaveViewController.spotRouter = self.spotRouter
        }
    }
    private var journeyID: UUID? {
        didSet {
            self.spotSaveViewController.journeyID = self.journeyID
        }
    }
    private var coordinate: [Double]? {
        didSet {
            self.spotSaveViewController.coordinate = self.coordinate
        }
    }
    
    // MARK: - UI Components
    
    private let cameraView = CameraView()
    private let shotButton = UIButton()
    private let galleryButton = UIButton()
    private let swapButton = UIButton()
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.spotViewModel.startCamera()
    }
    
    // MARK: - Configuration
    
    private func configure() {
        self.configureLayout()
        self.configureStyles()
        self.configureAction()
        self.configureState()
        self.configureDelegate()
    }
    
}

// MARK: - UI Configuration: Layout

private extension SpotViewController {
    
    func configureLayout() {
        [ self.cameraView,
          self.shotButton,
          self.galleryButton,
          self.swapButton ].forEach { uiComponent in
            self.view.addSubview(uiComponent)
            uiComponent.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.configureCameraViewLayout()
        self.configureShotButtonLayout()
        self.configureGalleryButtonLayout()
        self.configureSwapButtonLayout()
    }
    
    func configureCameraViewLayout() {
        NSLayoutConstraint.activate([
            self.cameraView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.cameraView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Metric.CameraView.bottomInset),
            self.cameraView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
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
        
        self.shotButton.backgroundColor = .white
        self.shotButton.layer.cornerRadius = Metric.ShotButton.radius
        self.shotButton.layer.borderColor = UIColor.msColor(.musicSpot).cgColor
        self.shotButton.layer.borderWidth = Metric.ShotButton.borderWidth
        
        self.galleryButton.backgroundColor = .msColor(.musicSpot)
        self.galleryButton.layer.cornerRadius = Metric.GalleryButton.radius
        self.galleryButton.setImage(UIImage(systemName: "photo.fill"), for: .normal)
        self.galleryButton.tintColor = .white
        
        self.swapButton.backgroundColor = .darkGray
        self.swapButton.layer.cornerRadius = Metric.SwapButton.radius
        self.swapButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
        self.swapButton.tintColor = .white
        
        self.spotSaveViewController.modalPresentationStyle = .fullScreen
    }
    
}

// MARK: - Configuration: Actions

private extension SpotViewController {
    
    func configureAction() {
        self.configureCameraSetting()
        self.configureShotButtonAction()
        self.configureSwapButtonAction()
        self.configureGalleryButtonAction()
    }
    
    func configureShotButtonAction() {
        let shotButtonAction = UIAction(handler: { _ in
            self.shotButtonTapped()
        })
        self.shotButton.addAction(shotButtonAction, for: .touchUpInside)
    }
    
    func configureSwapButtonAction() {
        let swapButtonAction = UIAction(handler: { _ in
            self.swapButtonTapped()
        })
        self.swapButton.addAction(swapButtonAction, for: .touchUpInside)
    }
    
    func configureGalleryButtonAction() {
        let galleryButtonAction = UIAction(handler: { _ in
            self.galleryButtonTapped()
        })
        self.galleryButton.addAction(galleryButtonAction, for: .touchUpInside)
    }
    
    private func configureCameraSetting() {
        self.spotViewModel.preset(screen: cameraView)
    }
    
}
    
// MARK: - Configuration: State

private extension SpotViewController {
    
    func configureState() {
        self.configurePickerState()
    }
    
    func configurePickerState() {
        self.picker.sourceType = .photoLibrary
        self.picker.allowsEditing = true
    }
    
}

// MARK: - Button Actions

private extension SpotViewController {
    
    func shotButtonTapped() {
        self.spotViewModel.shot()
    }
    
    func swapButtonTapped() {
        self.spotViewModel.swap()
    }
    
    func galleryButtonTapped() {
        self.present(self.picker, animated: false)
    }
}

// MARK: - Configuration: Delegate
    
private extension SpotViewController {
    
    func configureDelegate() {
        self.picker.delegate = self
        self.spotViewModel.delegate = self
    }
    
}

// MARK: - Delegate: ShotDelegate

extension SpotViewController: ShotDelegate {
    
    func update(imageData: Data?) {
        guard let imageData, let image = UIImage(data: imageData) else {
            MSLogger.make(category: .camera).debug("촬영된 image가 저장되지 않았습니다.")
            return
        }
        self.cameraView.layer.contents = imageData
        self.presentSpotSaveViewController(with: image)
    }
    
}

// MARK: - Delegate: ImagePickerDelegate

extension SpotViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                      info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.presentSpotSaveViewController(with: image)
    }
    
}

// MARK: - Functions

private extension SpotViewController {
    
    func presentSpotSaveViewController(with image: UIImage) {
        self.spotViewModel.stopCamera()
        self.spotSaveViewController.image = image
        self.presentedViewController?.dismiss(animated: false)
        self.presentingViewController?.dismiss(animated: false)
        self.present(self.spotSaveViewController, animated: true)
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let viewController = SpotViewController()
    return viewController
}
