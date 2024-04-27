//
//  JourneyListHeaderView.swift
//  Journey
//
//  Created by 이창준 on 4/27/24.
//

import SwiftUI

import MSData

public struct JourneyList: UIViewControllerRepresentable {
    
    public init() { }
    
    public func makeUIViewController(context: Context) -> some UIViewController {
        let journeyRepository = JourneyRepositoryImplementation()
        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
        return journeyListViewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    
}
