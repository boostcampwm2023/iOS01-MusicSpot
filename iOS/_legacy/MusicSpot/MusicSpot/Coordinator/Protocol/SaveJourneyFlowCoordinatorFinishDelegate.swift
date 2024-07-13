//
//  SaveJourneyFlowCoordinatorFinishDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 2024.01.11.
//

import Foundation

import MSDomain

protocol SaveJourneyFlowCoordinatorFinishDelegate: AnyObject {
    func shouldFinish(childCoordinator: Coordinator, with endedJourney: Journey)
}
