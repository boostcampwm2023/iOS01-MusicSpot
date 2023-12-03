//
//  SceneDelegate.swift
//  JourneyListDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import JourneyList
import MSData
import MSDesignSystem
import MSUIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    // MARK: - Functions
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        MSFont.registerFonts()
        
        let journeyRepository = JourneyRepositoryImplementation()
        let testViewModel = JourneyListViewModel(repository: journeyRepository)
        let testViewController = JourneyListViewController(viewModel: testViewModel)
        
        window.rootViewController = testViewController
        window.makeKeyAndVisible()
    }
    
}

