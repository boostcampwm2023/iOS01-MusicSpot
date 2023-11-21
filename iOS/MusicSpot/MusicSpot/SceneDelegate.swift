//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit

import MSUIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        let testViewController = UIViewController()
        testViewController.view.backgroundColor = .msColor(.primaryBackground)
        let bottomSheetViewController = UIViewController()
        bottomSheetViewController.view.backgroundColor = .msColor(.primaryButtonBackground)
        let bottomViewController = MSBottomSheetViewController(contentViewController: testViewController,
                                                               bottomSheetViewController: bottomSheetViewController,
                                                               configuration: .init(fullHeight: window.frame.height,
                                                                                    detentHeight: 300.0,
                                                                                    minimizedHeight: 100.0))
        window.rootViewController = bottomViewController
        window.makeKeyAndVisible()
    }
}
