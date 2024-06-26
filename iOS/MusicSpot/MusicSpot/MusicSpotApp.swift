//
//  MusicSpotApp.swift
//  MusicSpot
//
//  Created by 이창준 on 4/15/24.
//

import SwiftUI

import Home
import MSDesignSystem

@main
struct MusicSpotApp: App {
    @UIApplicationDelegateAdaptor
    private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {
    // Register SceneDelegate to UIScene
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}

@MainActor
final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        MSFont.registerFonts()
    }
}
