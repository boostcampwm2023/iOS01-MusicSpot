//
//  SceneDelegate.swift
//  RewindJourneyDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import MSDesignSystem
import RewindJourney

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties

    var window: UIWindow?
    
    // MARK: - Scene

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        MSFont.registerFonts()
        
        let repository = SpotRepositoryImplementation()
        let viewModel = RewindJourneyViewModel(photoURLs: [URL(string: "")!,
                                                           URL(string: "")!], repository: repository)
        let viewController = RewindJourneyViewController(viewModel: viewModel)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

}
