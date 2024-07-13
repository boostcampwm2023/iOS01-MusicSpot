//
//  MusicSpotApp.swift
//  MusicSpot
//
//  Created by 이창준 on 4/15/24.
//

import SwiftUI

import Home
import MSDesignSystem

// MARK: - MusicSpotApp

@main
struct MusicSpotApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            Home()
        }
    }
}

// MARK: - AppDelegate

@MainActor
final class AppDelegate: NSObject, UIApplicationDelegate {
    /// Register SceneDelegate to UIScene
    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions)
        -> UISceneConfiguration
    {
        let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        if connectingSceneSession.role == .windowApplication {
            configuration.delegateClass = SceneDelegate.self
        }
        return configuration
    }
}

// MARK: - SceneDelegate

@MainActor
final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    func scene(
        _: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions)
    {
        MSFont.registerFonts()
    }
}
