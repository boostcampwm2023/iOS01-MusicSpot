//
//  SceneDelegate.swift
//  SpotDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import Spot

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let spotVM = SpotViewModel()
        let spotVC = SpotViewController(viewModel: spotVM)
        
        let spotRepo = SpotRepositoryImplementation()
        let spotSaveVM = SpotSaveViewModel(repository: spotRepo,
                                              journeyID: UUID(),
                                              coordinate: [123.0, 123.0])
        let spotSaveVC = SpotSaveViewController(viewModel: spotSaveVM)
        
        window?.rootViewController = spotVC
        window?.makeKeyAndVisible()
    }

}

