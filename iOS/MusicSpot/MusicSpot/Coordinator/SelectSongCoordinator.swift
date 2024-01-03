//
//  SelectSongCoordinator.swift
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

final class SelectSongCoordinator: Coordinator {
    
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

extension SelectSongCoordinator: CoordinatorFinishDelegate {
    
    func shouldFinish(childCoordinator: Coordinator) {
        guard let selectSongViewController = self.rootViewController else { return }
        
        self.childCoordinators.removeAll { $0 === childCoordinator }
        self.navigationController.popToViewController(selectSongViewController, animated: true)
    }
    
}

// MARK: - SelectSong Navigation

extension SelectSongCoordinator: SelectSongNavigationDelegate {
    
    func navigateToSaveJourney(lastCoordinate: Coordinate, selectedSong: Song) {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: self.navigationController)
        saveJourneyCoordinator.finishDelegate = self
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start(lastCoordinate: lastCoordinate, selectedSong: selectedSong)
    }
    
    func popToHome() {
        self.finish()
    }
    
}
