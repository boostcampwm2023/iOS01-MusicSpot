//
//  RewindJourneyCoordinatorFinishDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 2024.01.12.
//

import Foundation

protocol RewindJourneyCoordinatorFinishDelegate: AnyObject {
    func rewindJourneyShouldFinish(childCooridnator: Coordinator)
}
