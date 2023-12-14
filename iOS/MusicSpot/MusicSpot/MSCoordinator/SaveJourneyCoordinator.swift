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

final class SaveJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: SelectSongCoordinatorDelegate?
    
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

// MARK: - SaveJourney Navigation

extension SaveJourneyCoordinator: SaveJourneyNavigationDelegate {
    
    func popToHome(with endedJourney: Journey) {
        self.delegate?.popToHome(from: self, with: endedJourney)
    }
    
}
