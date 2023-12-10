//
//  SaveJourneyNavigationDelegate.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.07.
//

import Foundation

import MSDomain

public protocol SaveJourneyNavigationDelegate: AnyObject {
    
    func popToHome(with endedJourney: Journey)
    
}
