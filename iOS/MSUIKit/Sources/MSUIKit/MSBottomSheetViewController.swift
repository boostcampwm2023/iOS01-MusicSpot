//
//  MSUIComponents.swift
//  MSUIKit
//
//  Created by 이창준 on 11/14/23.
//

import UIKit

import MSDesignSystem

open class MSBottomSheetViewController<Content: UIViewController, BottomSheet: UIViewController>
: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Configuration
    
    public struct BottomSheetConfiguration {
        let fullHeight: CGFloat
        let detentHeight: CGFloat
        let minimizedHeight: CGFloat
        
        var fullDetentDiff: CGFloat {
            return self.fullHeight - self.detentHeight
        }
        
        var detentMinimizedDiff: CGFloat {
            return self.detentHeight - self.minimizedHeight
        }
        
        public init(fullHeight: CGFloat,
                    detentHeight: CGFloat,
                    minimizedHeight: CGFloat) {
            self.fullHeight = fullHeight
            self.detentHeight = detentHeight
            self.minimizedHeight = minimizedHeight
        }
    }
    
    // MARK: - State
    
    public enum State {
        case full
        case detented
        case minimized
    }
    
    // MARK: - UI Components
    
    let contentViewController: Content
    let bottomSheetViewController: BottomSheet
    
    private var topConstraints: NSLayoutConstraint?
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(self.handlePanGesture(_:)))
        return panGesture
    }()
    
    // MARK: - Properties
    
    private let configuration: BottomSheetConfiguration
    var state: State = .minimized
    private let gestureVelocity: CGFloat = 750.0
    
    // MARK: - Initializer
    
    public init(contentViewController: Content,
                bottomSheetViewController: BottomSheet,
                configuration: BottomSheetConfiguration) {
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
        self.configureLayout()
        self.configureStyle()
        self.configureGesture()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    public func presentFullBottomSheet(animated: Bool = true) {
        self.topConstraints?.constant = -self.configuration.fullHeight
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .full
            }
        } else {
            self.view.layoutIfNeeded()
            self.state = .full
        }
    }
    
    public func presentDetentedBottomSheet(animated: Bool = true) {
        self.topConstraints?.constant = -self.configuration.detentHeight
        
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: .zero,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .detented
            }
        } else {
            self.view.layoutIfNeeded()
            self.state = .detented
        }
    }
    
    public func dismissBottomSheet(animated: Bool = true) {
        self.topConstraints?.constant = -self.configuration.minimizedHeight
        
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: .zero,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .minimized
            }
        } else {
            self.view.layoutIfNeeded()
            self.state = .minimized
        }
    }
    
    // MARK: - Pan Gesture
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.bottomSheetViewController.view)
        let velocity = sender.velocity(in: self.bottomSheetViewController.view)
        
        switch sender.state {
        case .began, .changed:
            self.handlePanChanged(translation: translation)
        case .ended:
            self.handlePanEnded(translation: translation, velocity: velocity)
        case .failed:
            self.handlePanFailed()
        default: break
        }
    }
    
    private func handlePanChanged(translation: CGPoint) {
        switch self.state {
        case .full:
            guard translation.y > 0 else { return }
            
            self.topConstraints?.constant = -(self.configuration.fullHeight - translation.y.magnitude)
            self.view.layoutIfNeeded()
        case .detented:
            if translation.y >= 0 { // 아래로 Pan
                self.topConstraints?.constant = -(self.configuration.detentHeight - translation.y.magnitude)
            } else if translation.y < 0 { // 위로 Pan
                self.topConstraints?.constant = -(self.configuration.detentHeight + translation.y.magnitude)
            }
            self.view.layoutIfNeeded()
        case .minimized:
            guard translation.y < 0 else { return }
            
            let newConstant = -(self.configuration.minimizedHeight + translation.y.magnitude)
            guard newConstant.magnitude < self.configuration.detentHeight else {
                self.presentDetentedBottomSheet()
                return
            }
            self.topConstraints?.constant = newConstant
            self.view.layoutIfNeeded()
        }
    }
    
    private func handlePanEnded(translation: CGPoint, velocity: CGPoint) {
        let yTransMagnitude = translation.y.magnitude
        switch self.state {
        case .full:
            if velocity.y < 0 {
                self.presentFullBottomSheet()
            } else if yTransMagnitude >= self.configuration.fullDetentDiff / 2 || velocity.y > self.gestureVelocity {
                self.presentDetentedBottomSheet()
            } else {
                self.presentFullBottomSheet()
            }
        case .detented:
            if yTransMagnitude >= self.configuration.fullDetentDiff / 2 || velocity.y < -self.gestureVelocity {
                self.presentFullBottomSheet()
            } else if translation.y >= self.configuration.detentMinimizedDiff / 2 || velocity.y > self.gestureVelocity {
                self.dismissBottomSheet()
            } else {
                self.presentDetentedBottomSheet()
            }
        case .minimized:
            if yTransMagnitude >= self.configuration.detentHeight / 2 || velocity.y < -self.gestureVelocity {
                self.presentDetentedBottomSheet()
            } else {
                self.dismissBottomSheet()
            }
        }
    }
    
    private func handlePanFailed() {
        switch self.state {
        case .full:
            self.presentFullBottomSheet()
        case .detented:
            self.presentDetentedBottomSheet()
        case .minimized:
            self.dismissBottomSheet()
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
    
}

// MARK: - UI Configuration

private extension MSBottomSheetViewController {
    
    func configureStyle() {
        self.bottomSheetViewController.view.layer.cornerRadius = 12.0
        self.bottomSheetViewController.view.clipsToBounds = true
    }
    
    func configureLayout() {
        self.addChild(self.contentViewController)
        self.addChild(self.bottomSheetViewController)
        
        self.view.addSubview(self.contentViewController.view)
        self.view.addSubview(self.bottomSheetViewController.view)
        
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            self.contentViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor),
            self.contentViewController.view.topAnchor
                .constraint(equalTo: self.view.topAnchor),
            self.contentViewController.view.bottomAnchor
                .constraint(equalTo: self.view.bottomAnchor)
        ])
        self.contentViewController.didMove(toParent: self)
        
        self.bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomSheetViewController.view.heightAnchor
                .constraint(equalToConstant: self.configuration.fullHeight),
            self.bottomSheetViewController.view.leftAnchor
                .constraint(equalTo: self.view.leftAnchor),
            self.bottomSheetViewController.view.rightAnchor
                .constraint(equalTo: self.view.rightAnchor)
        ])
        self.topConstraints = self.bottomSheetViewController.view.topAnchor
            .constraint(equalTo: self.view.bottomAnchor,
                        constant: -self.configuration.minimizedHeight)
        self.topConstraints?.isActive = true
        self.bottomSheetViewController.didMove(toParent: self)
    }
    
    func configureGesture() {
        self.bottomSheetViewController.view.addGestureRecognizer(self.panGesture)
    }
    
}
