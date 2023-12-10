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
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Functions
    
    func start(spotCoordinate coordinate: Coordinate) {
        let viewModel = SpotViewModel(coordinate: coordinate)
        let spotViewController = SpotViewController(viewModel: viewModel)
        self.navigationController.modalTransitionStyle = .coverVertical
        self.navigationController.pushViewController(spotViewController, animated: true)
        spotViewController.navigationDelegate = self
    }
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}

// MARK: - Spot Navigation

extension SpotCoordinator: SpotNavigationDelegate {
    
    func presentPhotos(from viewController: UIViewController) {
        guard let spotViewController = viewController as? SpotViewController else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = spotViewController
        spotViewController.present(picker, animated: true)
    }
    
    func presentSpotSave(using image: UIImage, coordinate: Coordinate) {
        let journeyRepository = JourneyRepositoryImplementation()
        let spotRepository = SpotRepositoryImplementation()
        let viewModel = SpotSaveViewModel(journeyRepository: journeyRepository,
                                          spotRepository: spotRepository,
                                          coordinate: coordinate)
        let spotSaveViewController = SpotSaveViewController(image: image, viewModel: viewModel)
        spotSaveViewController.modalPresentationStyle = .fullScreen
        spotSaveViewController.navigationDelegate = self
        self.navigationController.presentedViewController?.dismiss(animated: true)
        self.navigationController.present(spotSaveViewController, animated: true)
    }
    
    func dismissToSpot() {
        guard let presentedViewController = self.navigationController.presentedViewController,
              let spotSaveViewController = presentedViewController as? SpotSaveViewController else {
            return
        }
        
        spotSaveViewController.dismiss(animated: true)
    }
    
    func popToHome() {
        self.popToHome(from: self)
    }
    
}

// MARK: - HomeMap Coordinator

extension SpotCoordinator: HomeCoordinatorDelegate {
    
    func popToHome(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHome(from: self)
    }
    
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey) {
        //
    }
    
}
