//
//  SceneDelegate.swift
//  SelectSongDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import SelectSong

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        let navigationController = UINavigationController(rootViewController: UIViewController())
        window.rootViewController = navigationController
        
        let songRepository = SongRepositoryImplementation()
        let selectSongViewModel = SelectSongViewModel(repository: songRepository)
        let selectSongViewController = SelectSongViewController(viewModel: selectSongViewModel)
        navigationController.pushViewController(selectSongViewController, animated: true)
        
        window.makeKeyAndVisible()
    }

}
