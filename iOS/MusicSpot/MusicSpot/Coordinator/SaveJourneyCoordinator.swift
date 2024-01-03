//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import MusicKit
import UIKit

import MSData
import MSDomain
import SaveJourney

final class SaveJourneyCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    
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
        self.rootViewController = saveJourneyViewController
        
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }
    
}

// MARK: - SaveJourney Navigation

extension SaveJourneyCoordinator: SaveJourneyNavigationDelegate {
    
    func popToHome(with endedJourney: Journey) {
        
    }
    
    func popToSelectSong() {
        self.finish()
    }
    
}
