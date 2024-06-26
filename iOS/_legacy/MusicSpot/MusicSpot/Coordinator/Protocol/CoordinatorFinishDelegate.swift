//
//  CoordinatorFinishDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 2024.01.02.
//

protocol CoordinatorFinishDelegate: AnyObject {
    func shouldFinish(childCoordinator: Coordinator)
}
