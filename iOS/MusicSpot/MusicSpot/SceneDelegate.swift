//
//  SceneDelegate.swift
//  MusicSpot
//
//  Created by 이창준 on 11/13/23.
//

import UIKit

import JourneyList
import MSConstants
import MSData
import MSDesignSystem
import MSLogger

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    private var appCoordinator: Coordinator!
    
    #if DEBUG
    @UserDefaultsWrapped(UserDefaultsKey.recordingJourneyID, defaultValue: nil)
    var recordingJourneyID: String?
    @UserDefaultsWrapped(UserDefaultsKey.isFirstLaunch, defaultValue: false)
    var isFirstLaunch: Bool
    @UserDefaultsWrapped(UserDefaultsKey.isRecording, defaultValue: false)
    var isRecording: Bool
    
    var keychain = MSKeychainStorage()
    #endif
    
    // MARK: - Functions
    
    func scene(_ scene: UIScene,
               willConnectTo _: UISceneSession,
               options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        defer { self.window = window }
        
        MSLogger.make(category: .userDefaults).info("isFirstLaunch: \(self.isFirstLaunch.description)")
        MSLogger.make(category: .userDefaults).info("isRecording: \(self.isRecording.description)")
        MSLogger.make(category: .userDefaults).info("recordingJourneyID: \(self.recordingJourneyID ?? "No Recording")")
        
        #if DEBUG
        self.prepareToDebug()
        #endif
        MSFont.registerFonts()
        
        let musicSpotNavigationController = self.makeNavigationController()
        let appCoordinator = AppCoordinator(navigationController: musicSpotNavigationController)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
        
        window.rootViewController = musicSpotNavigationController
        window.makeKeyAndVisible()
    }
    
}

// MARK: - NavigationController

private extension SceneDelegate {
    
    func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.tintColor = .msColor(.primaryTypo)
        return navigationController
    }
    
}


// MARK: - Debug

#if DEBUG
import MSKeychainStorage
import MSUserDefaults

private extension SceneDelegate {
    
    func prepareToDebug() {
        self.isFirstLaunch = true
        self.recordingJourneyID = nil
        do {
            try self.keychain.deleteAll()
        } catch {
            MSLogger.make(category: .keychain).error("키체인 초기화 실패")
        }
    }
    
}
#endif
