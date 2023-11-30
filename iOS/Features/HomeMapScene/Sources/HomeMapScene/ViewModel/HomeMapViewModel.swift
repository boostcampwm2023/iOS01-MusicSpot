//
//  HomeMapViewModel.swift
//
//
//  Created by 윤동주 on 11/26/23.
//

import Foundation

class HomeMapViewModel {
    
    // MARK: - Properties

    var journeys: [Journey]
    var user: User
    var currentJourney: Journey?
    
    // MARK: - Initializer

    init(journeys: [Journey], user: User, currentJourney: Journey? = nil) {
        self.journeys = journeys
        self.user = user
        self.currentJourney = currentJourney
    }
    
    var userState: Bool {
        self.user.isRecording
    }
    
    // MARK: - Functions

    func toggleIsRecording() {
        user.isRecording.toggle()
    }
}
