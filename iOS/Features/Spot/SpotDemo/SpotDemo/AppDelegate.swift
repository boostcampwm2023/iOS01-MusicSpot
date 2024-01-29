//
//  AppDelegate.swift
//  SpotDemo
//
//  Created by 이창준 on 2023.11.29.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}
