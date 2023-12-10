//
//  SelectSongCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit
import MusicKit

import MSData
import MSDomain
import SaveJourney
import SelectSong

protocol SelectSongCoordinatorDelegate: AnyObject {
    
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey)
    func popToSelectSong(from coordinator: Coordinator)
    
}

final class SelectSongCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    weak var delegate: HomeCoordinatorDelegate?
    
    // MARK: - Initializer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Functions
    
    func start(lastCoordinate: Coordinate) {
        let songRepository = SongRepositoryImplementation()
        let selectSongViewModel = SelectSongViewModel(lastCoordinate: lastCoordinate,
                                                      repository: songRepository)
        let searchMusicViewController = SelectSongViewController(viewModel: selectSongViewModel)
        searchMusicViewController.navigationDelegate = self
        self.navigationController.pushViewController(searchMusicViewController, animated: true)
    }
    
}

// MARK: - SelectSong Navigation

extension SelectSongCoordinator: SelectSongNavigationDelegate {
    
    func navigateToHomeMap() {
        self.delegate?.popToHome(from: self)
    }
    
    func navigateToSaveJourney(lastCoordinate: Coordinate, selectedSong: Song) {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: self.navigationController)
        saveJourneyCoordinator.delegate = self
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start(lastCoordinate: lastCoordinate, selectedSong: selectedSong)
    }
    
}

// MARK: - SelectSong Coordinator

extension SelectSongCoordinator: SelectSongCoordinatorDelegate {
    
    func popToHome(from coordinator: Coordinator, with endedJourney: Journey) {
        self.childCoordinators.removeAll()
        self.delegate?.popToHome(from: coordinator)
    }
    
    func popToSelectSong(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
