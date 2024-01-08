//
//  RewindJourneyCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

import MSData
import MSDomain
import RewindJourney

final class RewindJourneyCoordinator: Coordinator {
    
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
    
    func start(with urls: [URL], music: Music) {
        let spotRepository = SpotRepositoryImplementation()
        let songRepository = SongRepositoryImplementation()
        let viewModel = RewindJourneyViewModel(photoURLs: urls,
                                               music: music,
                                               spotRepository: spotRepository,
                                               songRepository: songRepository)
        let rewindJourneyViewController = RewindJourneyViewController(viewModel: viewModel)
        rewindJourneyViewController.navigationDelegate = self
        self.rootViewController = rewindJourneyViewController
        
        self.navigationController.pushViewController(rewindJourneyViewController, animated: true)
    }
    
}

// MARK: - RewindJourney Navigation

extension RewindJourneyCoordinator: RewindJourneyNavigationDelegate {
    
    func popToHome() {
        self.finish()
    }
    
}
