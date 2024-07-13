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
    public func makeUIViewController(context _: Context) -> some UIViewController {
//        let journeyRepository = JourneyRepositoryImplementation()
//        let journeyListViewModel = JourneyListViewModel(repository: journeyRepository)
//        let journeyListViewController = JourneyListViewController(viewModel: journeyListViewModel)
//        return journeyListViewController
        UIViewController()
    }

    public func updateUIViewController(_: UIViewControllerType, context _: Context) {
        //
    }
}
