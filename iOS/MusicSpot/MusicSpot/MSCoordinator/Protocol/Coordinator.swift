//
//  Coordinator.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    var childCoordinators: [Coordinator] { get set }
    
}
