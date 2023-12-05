//
//  SearchMusicCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

import MSData
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
        let song = Song(title: "OMG", artist: "New Jeans", albumArtURL: nil)
        let spotRepository = SpotRepositoryImplementation()
        let saveJourneyViewModel = SaveJourneyViewModel(selectedSong: song, spotRepository: spotRepository)
        let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
        self.navigationController.pushViewController(saveJourneyViewController, animated: true)
    }
    
}

// MARK: - SaveJourneyViewController

//extension SaveJourneyCoordinator: SaveJourneyViewControllerDelegate {
//    
//    func navigateToHomeMap() {
//        self.delegate?.popToHome(from: self)
//    }
//    
//    func navigateToSearchMusic() {
//        self.delegate?.popToSearchMusic(from: self)
//    }
//    
//}
