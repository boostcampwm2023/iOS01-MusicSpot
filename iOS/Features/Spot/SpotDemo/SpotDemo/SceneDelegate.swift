//
//  SceneDelegate.swift
//  SpotDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import MSDesignSystem
import Spot

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
        
        let spotViewModel = SpotViewModel()
        let spotViewController = SpotViewController(viewModel: spotViewModel)
        
        let spotRepository = SpotRepositoryImplementation()
        let spotSaveViewModel = SpotSaveViewModel(repository: spotRepository,
                                                  journeyID: "6571bef418be25527c66dc04",
                                                  coordinate: "[10, 10]")
        let spotSaveViewController = SpotSaveViewController(viewModel: spotSaveViewModel)
        
        window.rootViewController = spotSaveViewController
        window.makeKeyAndVisible()
    }

}
