//
//  SceneDelegate.swift
//  RewindJourneyDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit
import MSDesignSystem
import RewindJourney

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        MSFont.registerFonts()
        window = UIWindow(windowScene: windowScene)
        let viewController = RewindJourneyViewController()
        viewController.images = [UIImage(systemName: "pencil")!,
                                  UIImage(systemName: "pencil")!]
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }

}