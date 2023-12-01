//
//  HomeBottomSheetViewController.swift
//  Home
//
//  Created by 이창준 on 2023.12.01.
//

import UIKit

import JourneyList
import MSUIKit
import NavigateMap

public protocol HomeViewControllerDelegate: AnyObject {
    
    func navigateToSpot()
    func navigateToRewind()
    
}

public final class HomeBottomSheetViewController
: MSBottomSheetViewController<NavigateMapViewController, JourneyListViewController> {
    
    // MARK: - Properties
    
    public weak var delegate: HomeViewControllerDelegate?
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
}
