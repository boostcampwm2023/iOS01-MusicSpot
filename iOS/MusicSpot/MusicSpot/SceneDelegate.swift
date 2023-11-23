//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit

import JourneyList
import MSDesignSystem

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        MSFont.registerFonts()
        
        let viewModel = JourneyListViewModel()
        let testViewController = JourneyListViewController(viewModel: viewModel)
        window.rootViewController = testViewController
        window.makeKeyAndVisible()
    }
}
