//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit

import JourneyList
import MSData
import MSDesignSystem

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
        
        MSFont.registerFonts()
        
        let journeyRepository = JourneyRepositoryImpl()
        let testViewModel = JourneyListViewModel(repository: journeyRepository)
        let testViewController = JourneyListViewController(viewModel: testViewModel)
        window.rootViewController = testViewController
        window.makeKeyAndVisible()
    }
    
}
