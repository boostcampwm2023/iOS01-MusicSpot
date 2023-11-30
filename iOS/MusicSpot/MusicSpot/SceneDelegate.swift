//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit
import NavigateMap

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Functions
    
    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        let musicSpotNavigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: musicSpotNavigationController)
        window.rootViewController = musicSpotNavigationController
        
        appCoordinator.start()
        
        window.makeKeyAndVisible()
    }
    
}
