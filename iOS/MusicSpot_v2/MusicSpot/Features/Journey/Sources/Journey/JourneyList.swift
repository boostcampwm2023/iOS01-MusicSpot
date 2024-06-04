//
//  JourneyListHeaderView.swift
//  Journey
//
//  Created by 이창준 on 4/27/24.
//

import SwiftUI

public struct JourneyList: UIViewControllerRepresentable {
    public init() { }

    // TODO: Repository 재적용 후 복구
    public func makeUIViewController(context: Context) -> some UIViewController {
//        let journeyRepository = JourneyRepositoryImplementation()
//        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
//        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
//        return journeyListViewController
        return UIViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}
