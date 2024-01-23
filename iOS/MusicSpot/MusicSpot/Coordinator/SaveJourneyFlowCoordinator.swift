//
//  SaveJourneyFlowCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import MusicKit
import UIKit

import MSData
import MSDomain
import SaveJourney
import SelectSong

final class SaveJourneyFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    var childCoordinators: [Coordinator] = []
    weak var finishDelegate: CoordinatorFinishDelegate?
    weak var saveJourneyFinishDelegate: SaveJourneyFlowCoordinatorFinishDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    /// rootViewController: SelectSongViewController
    func start(lastCoordinate: Coordinate) {
        let songRepository = SongRepositoryImplementation()
        let selectSongViewModel = SelectSongViewModel(lastCoordinate: lastCoordinate,
                                                      repository: songRepository)
        let selectSongViewController = SelectSongViewController(viewModel: selectSongViewModel)
        selectSongViewController.navigationDelegate = self
        self.rootViewController = selectSongViewController
        
        self.navigationController.pushViewController(selectSongViewController, animated: true)
    }
    
}

// MARK: - Finish Delegate

extension SaveJourneyFlowCoordinator: CoordinatorFinishDelegate {
    
    func shouldFinish(childCoordinator: Coordinator) {
        guard let selectSongViewController = self.rootViewController else { return }
        
        self.childCoordinators.removeAll { $0 === childCoordinator }
        self.navigationController.popToViewController(selectSongViewController, animated: true)
    }
    
}

// MARK: - SelectSong Navigation

extension SaveJourneyFlowCoordinator: SelectSongNavigationDelegate {
    
    func navigateToSaveJourney(lastCoordinate: Coordinate,
                               selectedSong: Song) {
        let journeyRepository = JourneyRepositoryImplementation()
        let saveJourneyViewModel = SaveJourneyViewModel(lastCoordinate: lastCoordinate,
                                                        selectedSong: selectedSong,
                                                        journeyRepository: journeyRepository)
        let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
        saveJourneyViewController.navigationDelegate = self
        
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }
    
    func popToHome() {
        self.finish()
    }
    
}

// MARK: - SaveJourney Navigation

extension SaveJourneyFlowCoordinator: SaveJourneyNavigationDelegate {
    
    func popToHome(with endedJourney: Journey) {
        self.saveJourneyFinishDelegate?.shouldFinish(childCoordinator: self, with: endedJourney)
    }
    
    func popToSelectSong() {
        guard self.navigationController.topViewController is SaveJourneyViewController else { return }
        
        self.navigationController.popViewController(animated: true)
    }
    
}
