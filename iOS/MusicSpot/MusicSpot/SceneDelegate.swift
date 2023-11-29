//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        
        let musicSpotNavigationController = UINavigationController()
        let appCoordinator = AppCoordinator(navigationController: musicSpotNavigationController)
        window?.rootViewController = musicSpotNavigationController
        
        appCoordinator.start()
        window?.makeKeyAndVisible()
    }
}
