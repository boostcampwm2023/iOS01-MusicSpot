//
//  SettingCoordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

//final class SettingCoordinator: Coordinator {
//    
//    // MARK: - Properties
//    
//    var navigationController: UINavigationController
//    
//    var childCoordinators: [Coordinator] = []
//    
//    var delegate: HomeMapCoordinatorDelegate?
//    
//    // MARK: - Initializer
//    
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    // MARK: - Functions
//    
//    func start() {
//        let settingViewController = SettingViewController()
//        settingViewController.delegate = self
//        self.navigationController.pushViewController(settingViewController, animated: true)
//    }
//    
//}
//
//// MARK: - SettingViewController
//
//extension SettingCoordinator: SettingViewControllerDelegate {
//    
//    func navigateToHomeMap() {
//        self.delegate?.popToHomeMap(from: self)
//    }
//    
//}
//
//// MARK: - HomeMap Coordinator
//
//extension SettingCoordinator: HomeMapCoordinatorDelegate {
//    
//    func popToHomeMap(from coordinator: Coordinator) {
//        self.childCoordinators.removeAll()
//        self.navigationController.popViewController(animated: true)
//        self.delegate?.popToHomeMap(from: self)
//    }
//    
//}
