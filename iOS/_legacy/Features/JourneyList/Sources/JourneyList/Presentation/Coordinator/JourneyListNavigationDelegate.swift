//
//  JourneyListNavigationDelegate.swift
//  Home
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

import MSDomain

public protocol JourneyListNavigationDelegate: AnyObject {
    func navigateToRewindJourney(with urls: [URL], music: Music)
}
