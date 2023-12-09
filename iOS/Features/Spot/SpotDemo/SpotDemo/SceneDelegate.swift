//
//  SceneDelegate.swift
//  SpotDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import MSDesignSystem
import MSDomain
import Spot

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        MSFont.registerFonts()
//        let spotVM = SpotViewModel()
//        let spotVC = SpotViewController(viewModel: spotVM)
        
        let spotRepo = SpotRepositoryImplementation()
        let spotSaveVM = SpotSaveViewModel(repository: spotRepo,
                                           journeyID: "6571bef418be25527c66dc04",
                                           coordinate: Coordinate(latitude: 10, longitude: 10))
        let spotSaveVC = SpotSaveViewController(viewModel: spotSaveVM)
        
        window?.rootViewController = spotSaveVC
        window?.makeKeyAndVisible()
    }

}

