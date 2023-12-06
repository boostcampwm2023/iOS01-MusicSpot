//
//  RewindJourneyViewController+Gesture.swift
//  RewindJourney
//
//  Created by 전민건 on 12/6/23.
//

import Foundation
import UIKit

fileprivate enum Constants {
    
    static let movedXPositionToBackScene: CGFloat = 50.0
    static let animationDuration: Double = 0.3
    
}

internal extension RewindJourneyViewController {
    
    func configureLeftToRightSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureDismiss(_:)))
            self.view.addGestureRecognizer(panGesture)
    }

    @objc
    private func panGestureDismiss(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view.window)
        let width = self.view.frame.width
        let height = self.view.frame.height
        switch sender.state {
        case .began:
            self.initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.x - self.initialTouchPoint.x > .zero {
                self.view.frame = CGRect(x: touchPoint.x - self.initialTouchPoint.x,
                                         y: .zero,
                                         width: width,
                                         height: height)
            }
        case .ended, .cancelled:
            if touchPoint.x - self.initialTouchPoint.x > Constants.movedXPositionToBackScene {
                self.navigationDelegate?.popToHomeMap()
            } else {
                self.view.frame = CGRect(x: .zero,
                                         y: .zero,
                                         width: width,
                                         height: height)
            }
        default:
            UIView.animate(withDuration: Constants.animationDuration) {
                self.view.frame = CGRect(x: .zero,
                                         y: .zero,
                                         width: width,
                                         height: height)
            }
        }
    }
    
}
