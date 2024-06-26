//
//  RewindJourneyViewController+Gesture.swift
//  RewindJourney
//
//  Created by 전민건 on 12/6/23.
//

import Foundation
import UIKit

// MARK: - Constants

private enum Metric {
    static let movedYPositionToBackScene: CGFloat = 50.0
    static let animationDuration: Double = 0.3
}

// MARK: - Gesture

internal extension RewindJourneyViewController {
    func configureLeftToRightSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panGestureDismiss(_:)))
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
            if touchPoint.y - self.initialTouchPoint.y > .zero {
                self.view.frame = CGRect(x: .zero,
                                         y: touchPoint.y - self.initialTouchPoint.y,
                                         width: width,
                                         height: height)
            }
        case .ended, .cancelled:
            if touchPoint.y - self.initialTouchPoint.y > Metric.movedYPositionToBackScene {
                self.navigationDelegate?.popToHome()
            } else {
                self.view.frame = CGRect(x: .zero,
                                         y: .zero,
                                         width: width,
                                         height: height)
            }
        default:
            UIView.animate(withDuration: Metric.animationDuration) { [weak self] in
                self?.view.frame = CGRect(x: .zero,
                                          y: .zero,
                                          width: width,
                                          height: height)
            }
        }
    }
}
