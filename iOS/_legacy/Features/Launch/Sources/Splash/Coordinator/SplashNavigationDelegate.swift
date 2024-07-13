//
//  SplashNavigationDelegate.swift
//  Splash
//
//  Created by 이창준 on 2024.02.14.
//

import Foundation

public protocol SplashNavigationDelegate: AnyObject {
    func navigateToHome()
    func navigateToUpdate(releaseNote: String?)
}
