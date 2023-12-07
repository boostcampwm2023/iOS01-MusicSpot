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

protocol SelectSongCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator)
    func popToSearchMusic(from coordinator: Coordinator)
    
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
    
    func start(recordingJourney: RecordingJourney, lastCoordinate: Coordinate) {
        let songRepository = SongRepositoryImplementation()
        let selectSongViewModel = SelectSongViewModel(recordingJourney: recordingJourney,
                                                      lastCoordinate: lastCoordinate,
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
    
    func navigateToSaveJourney(recordingJourney: RecordingJourney,
                               lastCoordinate: Coordinate,
                               selectedSong: Song) {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start(recordingJourney: recordingJourney,
                                     lastCoordinate: lastCoordinate,
                                     selectedSong: selectedSong)
    }
    
}

// MARK: - SelectSong Coordinator

extension SelectSongCoordinator: SelectSongCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHome(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
