//
//  SpotCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import Spot

final class SpotCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        let spotViewController = SpotViewController()
        self.navigationController.pushViewController(spotViewController, animated: true)
        spotViewController.navigationDelegate = self
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
    
    func presentSpotSave(using image: UIImage) {
        let spotSaveViewController = SpotSaveViewController()
        spotSaveViewController.modalPresentationStyle = .fullScreen
        spotSaveViewController.image = image
        spotSaveViewController.navigationDelegate = self
        self.navigationController.present(spotSaveViewController, animated: true)
    }
    
    func dismissToSpot() {
        guard let presentedViewController = self.navigationController.presentedViewController,
              let spotSaveViewController = presentedViewController as? SpotSaveViewController else {
            return
        }
        spotSaveViewController.dismiss(animated: true)
    }
    
    func navigateToSelectSong() {
        let selectSongCoordinator = SelectSongCoordinator(navigationController: self.navigationController)
        selectSongCoordinator.delegate = self
        self.childCoordinators.append(selectSongCoordinator)
        selectSongCoordinator.start()
    }
    
}

// MARK: - HomeMap Coordinator

extension SpotCoordinator: HomeCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
}
