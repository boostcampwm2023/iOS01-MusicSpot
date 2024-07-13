//
//  Coordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get set }
    
    var childCoordinators: [Coordinator] { get set }
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    
    init(navigationController: UINavigationController)
    
    func start()
    func finish()
}

extension Coordinator {
    func start() { }
    
    func finish() {
        self.childCoordinators.removeAll()
        self.finishDelegate?.shouldFinish(childCoordinator: self)
    }
}
