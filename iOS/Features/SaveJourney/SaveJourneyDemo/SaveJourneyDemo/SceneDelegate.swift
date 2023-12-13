//
//  SceneDelegate.swift
//  SaveJourneyDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

import MSData
import MSDesignSystem
import SaveJourney

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
        
        let song = Song(title: "OMG", artist: "NewJeans", albumArtURL: URL(string: "https://naver.com")!)
        let spotRepository = SpotRepositoryImplementation()
        let saveJourneyViewModel = SaveJourneyViewModel(selectedSong: song,
                                                        spotRepository: spotRepository)
        let saveJourneyViewController = SaveJourneyViewController(viewModel: saveJourneyViewModel)
        let navigationViewController = UINavigationController(rootViewController: saveJourneyViewController)
        
        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
    
}
