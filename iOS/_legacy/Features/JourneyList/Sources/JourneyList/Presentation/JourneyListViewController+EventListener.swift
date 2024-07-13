//
//  JourneyListViewController+EventListener.swift
//  JourneyList
//
//  Created by 이창준 on 2023.12.10.
//

import Foundation

import MSDomain

extension JourneyListViewController {
    public func visibleJourneysDidUpdated(_ visibleJourneys: [Journey]) {
        self.viewModel.trigger(.visibleJourneysDidUpdated(visibleJourneys))
    }
}
