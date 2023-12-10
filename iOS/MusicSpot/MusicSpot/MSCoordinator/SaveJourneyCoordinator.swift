//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit
import MusicKit

import MSData
import MSDomain
import SaveJourney

protocol SaveJourneyCoordinatorDelegate: AnyObject {
    
    func popToHomeMap(from coordinator: Coordinator)
    
}

final class SaveJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var delegate: SelectSongCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start(lastCoordinate: Coordinate,
               selectedSong: Song) {
        let journeyRepository = JourneyRepositoryImplementation()
        let saveJourneyViewModel = SaveJourneyViewModel(lastCoordinate: lastCoordinate,
                                                        selectedSong: selectedSong,
                                                        journeyRepository: journeyRepository)
        let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
        saveJourneyViewController.navigationDelegate = self
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }
    
}

// MARK: - SaveJourneyViewController

extension SaveJourneyCoordinator: SaveJourneyNavigationDelegate {
    
    func popToHome() {
        self.delegate?.popToHomeMap(from: self)
    }
    
}

// MARK: - SelectSong Coordinator

extension SaveJourneyCoordinator: SaveJourneyCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
}
