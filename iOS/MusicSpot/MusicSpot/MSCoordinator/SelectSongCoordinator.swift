//
//  SelectSongCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

import MSData
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
    
    func start() {
        let songRepository = SongRepositoryImplementation()
        let selectSongViewModel = SelectSongViewModel(repository: songRepository)
        let searchMusicViewController = SelectSongViewController(viewModel: selectSongViewModel)
        searchMusicViewController.navigationDelegate = self
        self.navigationController.pushViewController(searchMusicViewController, animated: true)
    }
    
}

// MARK: - SelectSong Navigation

extension SelectSongCoordinator: SelectSongNavigationDelegate {
    
    func navigateToHomeMap() {
        self.delegate?.popToHomeMap(from: self)
    }
    
    func navigateToSaveJourney() {
        let saveJourneyCoordinator = SaveJourneyCoordinator(navigationController: self.navigationController)
        self.childCoordinators.append(saveJourneyCoordinator)
        saveJourneyCoordinator.start()
    }
    
}

// MARK: - SelectSong Coordinator

extension SelectSongCoordinator: SelectSongCoordinatorDelegate {
    
    func popToHomeMap(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
        self.navigationController.popViewController(animated: true)
        self.delegate?.popToHomeMap(from: self)
    }
    
    func popToSearchMusic(from coordinator: Coordinator) {
        self.childCoordinators.removeAll()
    }
    
}
