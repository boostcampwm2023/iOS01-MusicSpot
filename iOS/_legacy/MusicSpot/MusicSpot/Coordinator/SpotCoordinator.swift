//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSData
import MSDomain
import Spot

final class SpotCoordinator: Coordinator {
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var spotFinishDelegate: SpotCoordinatorFinishDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start(spotCoordinate coordinate: Coordinate) {
        let viewModel = SpotViewModel(coordinate: coordinate)
        let spotViewController = SpotViewController(viewModel: viewModel)
        spotViewController.navigationDelegate = self
        self.rootViewController = spotViewController
        
        self.navigationController.pushViewController(spotViewController, animated: true)
    }
}

// MARK: - Spot Navigation

extension SpotCoordinator: SpotNavigationDelegate {
    func presentPhotoLibrary(from viewController: UIViewController) {
        guard let spotViewController = viewController as? SpotViewController else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = spotViewController
        self.navigationController.present(picker, animated: true)
    }
    
    func presentSaveSpot(using image: UIImage, coordinate: Coordinate) {
        let journeyRepository = JourneyRepositoryImplementation()
        let spotRepository = SpotRepositoryImplementation()
        let viewModel = SaveSpotViewModel(journeyRepository: journeyRepository,
                                          spotRepository: spotRepository,
                                          coordinate: coordinate)
        let spotSaveViewController = SaveSpotViewController(image: image, viewModel: viewModel)
        spotSaveViewController.modalPresentationStyle = .fullScreen
        spotSaveViewController.navigationDelegate = self
        
        if let presentedViewController = self.navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true) { [weak self] in
                self?.navigationController.present(spotSaveViewController, animated: true)
            }
        } else {
            self.navigationController.present(spotSaveViewController, animated: true)
        }
    }
    
    func dismissToSpot() {
        guard let presentedViewController = self.navigationController.presentedViewController,
              let spotSaveViewController = presentedViewController as? SaveSpotViewController else {
            return
        }
        
        spotSaveViewController.dismiss(animated: true)
    }
    
    func popToHome(with spot: Spot?, photoData: Data?) {
        if let presentedViewController = self.navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.spotFinishDelegate?.shouldFinish(childCoordinator: self, with: spot, photoData: photoData)
            }
        } else {
            self.spotFinishDelegate?.shouldFinish(childCoordinator: self, with: spot, photoData: photoData)
        }
    }
}
