//
//  JourneyListNavigationDelegate.swift
//  Home
//
//  Created by 이창준 on 2023.12.05.
//

import Foundation

public protocol JourneyListNavigationDelegate: AnyObject {
    
    func navigateToRewindJourney(with urls: [URL])
    
}
