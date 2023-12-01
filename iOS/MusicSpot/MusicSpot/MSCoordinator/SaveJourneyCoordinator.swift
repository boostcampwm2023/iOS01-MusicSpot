//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

import SaveJourney

final class SaveJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
//    var delegate: SearchMusicCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start() {
        let saveJourneyViewModel = SaveJourneyViewModel()
        let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
//        saveJourneyViewController.delegate = self
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }
    
}

// MARK: - SaveJourneyViewController

//extension SaveJourneyCoordinator: SaveJourneyViewControllerDelegate {
//    
//    func navigateToHomeMap() {
//        self.delegate?.popToHomeMap(from: self)
//    }
//    
//    func navigateToSearchMusic() {
//        self.delegate?.popToSearchMusic(from: self)
//    }
//    
//}
