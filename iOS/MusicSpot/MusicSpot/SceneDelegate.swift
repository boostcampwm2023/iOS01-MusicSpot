//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit
import HomeMapScene

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = HomeMapViewController()
        self.window = window
        window.makeKeyAndVisible()
    }
}
