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
        let viewModel = RewindJourneyViewModel(photoURLs: [URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fm.youtube.com%2Fwatch%3Fv%3DWs5VJ1Ig1EY&psig=AOvVaw3vmGcqNwsTcGM-J59la6qB&ust=1702326229170000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCNDNosTZhYMDFQAAAAAdAAAAABAD")!,
                                                           URL(string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fnamu.wiki%2Fw%2F%25EC%25BC%2580%25EC%259D%25B8%2528%25EC%259D%25B8%25ED%2584%25B0%25EB%2584%25B7%2520%25EB%25B0%25A9%25EC%2586%25A1%25EC%259D%25B8%2529%2F%25EB%25B0%2588&psig=AOvVaw0qY6irtYIsc68tIwsIwJF4&ust=1702326282656000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOjSpt3ZhYMDFQAAAAAdAAAAABAD")!], repository: repository)
        let viewController = RewindJourneyViewController(viewModel: viewModel)
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }

}
