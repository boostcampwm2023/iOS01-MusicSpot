//
//  MSUIComponents.swift
//  MSUIKit
//
//  Created by 이창준 on 11/14/23.
//

import UIKit

import MSDesignSystem
import MSLogger

open class MSBottomSheetViewController<Content: UIViewController, BottomSheet: UIViewController>
: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - State
    
    public enum State: String {
        case full
        case detented
        case minimized
    }
    
    // MARK: - UI Components
    
    public let contentViewController: Content
    public let bottomSheetViewController: BottomSheet
    
    private let resizeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    private var topConstraints: NSLayoutConstraint?
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer()
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(self.handlePanGesture(_:)))
        return panGesture
    }()
    
    // MARK: - Properties
    
    public var configuration: MSBottomSheetViewController.Configuration?
    private let gestureVelocity: CGFloat = 750.0
    
    public var state: State = .minimized {
        willSet { self.stateDidChanged(newValue) }
    }
    
    // MARK: - Initializer
    
    public init(contentViewController: Content,
                bottomSheetViewController: BottomSheet) {
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyle()
        self.configureLayout()
        self.configureGesture()
    }
    
    // MARK: - Functions
    
    open func stateDidChanged(_ state: State) {
        MSLogger.make(category: .uiKit).log("Bottom Sheet 상태가 \(state.rawValue)로 업데이트 되었습니다.")
        
        if case .full = state {
            self.resizeIndicator.isHidden = true
        }
    }
    
    private func presentFullBottomSheet(animated: Bool = true) {
        guard let configuration = self.configuration else { return }
        self.topConstraints?.constant = -configuration.fullHeight
        
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
    
    private func presentDetentedBottomSheet(animated: Bool = true) {
        guard let configuration = self.configuration else { return }
        self.topConstraints?.constant = -configuration.detentHeight
        
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
    
    private func dismissBottomSheet(animated: Bool = true) {
        guard let configuration = self.configuration else { return }
        self.topConstraints?.constant = -configuration.minimizedHeight
        
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
    
    public func hideBottomSheet(animated: Bool = true) {
        self.topConstraints?.constant = .zero
        
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: .zero,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
    
    public func showBottomSheet(animated: Bool = true) {
        guard let configuration = self.configuration else { return }
        self.topConstraints?.constant = -configuration.minimizedHeight
        
        if animated {
            UIView.animate(withDuration: 0.5,
                           delay: .zero,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [.curveEaseInOut]) {
                self.view.layoutIfNeeded()
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
        guard let configuration = self.configuration else { return }
        
        self.resizeIndicator.isHidden = false
        
        switch self.state {
        case .full:
            guard translation.y > 0 else { return }
            
            self.topConstraints?.constant = -(configuration.fullHeight - translation.y.magnitude)
            self.view.layoutIfNeeded()
        case .detented:
            if translation.y >= 0 { // 아래로 Pan
                self.topConstraints?.constant = -(configuration.detentHeight - translation.y.magnitude)
            } else if translation.y < 0 { // 위로 Pan
                self.topConstraints?.constant = -(configuration.detentHeight + translation.y.magnitude)
            }
            self.view.layoutIfNeeded()
        case .minimized:
            guard translation.y < 0 else { return }
            
            let newConstant = -(configuration.minimizedHeight + translation.y.magnitude)
            self.topConstraints?.constant = newConstant
            self.view.layoutIfNeeded()
        }
    }
    
    private func handlePanEnded(translation: CGPoint, velocity: CGPoint) {
        guard let configuration = self.configuration else { return }
        
        let yTransMagnitude = translation.y.magnitude
        switch self.state {
        case .full:
            if velocity.y < 0 {
                self.presentFullBottomSheet()
            } else if yTransMagnitude >= configuration.fullDetentDiff / 2 || velocity.y > self.gestureVelocity {
                self.presentDetentedBottomSheet()
            } else {
                self.presentFullBottomSheet()
            }
        case .detented:
            if translation.y <= -configuration.fullDetentDiff / 2 || velocity.y < -self.gestureVelocity {
                self.presentFullBottomSheet()
            } else if translation.y >= configuration.detentMinimizedDiff / 2 || velocity.y > self.gestureVelocity {
                self.dismissBottomSheet()
            } else {
                self.presentDetentedBottomSheet()
            }
        case .minimized:
            if yTransMagnitude >= configuration.detentHeight / 2 || velocity.y < -self.gestureVelocity {
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
    
}

// MARK: - UI Configuration

private extension MSBottomSheetViewController {
    
    func configureStyle() {
        self.bottomSheetViewController.view.layer.cornerRadius = 12.0
        self.bottomSheetViewController.view.clipsToBounds = true
        
        self.configuration?.standardMetric = self.view.frame.height
    }
    
    func configureLayout() {
        guard let configuration = self.configuration else { return }
        
        self.addChild(self.contentViewController)
        self.addChild(self.bottomSheetViewController)
        
        self.view.addSubview(self.contentViewController.view)
        self.view.addSubview(self.bottomSheetViewController.view)
        
        self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.contentViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.contentViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.contentViewController.didMove(toParent: self)
        
        self.bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomSheetViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bottomSheetViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bottomSheetViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        self.topConstraints = self.bottomSheetViewController.view.topAnchor
            .constraint(equalTo: self.view.bottomAnchor,
                        constant: -configuration.minimizedHeight)
        self.topConstraints?.isActive = true
        self.bottomSheetViewController.didMove(toParent: self)
        
        self.bottomSheetViewController.view.addSubview(self.resizeIndicator)
        self.resizeIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.resizeIndicator.widthAnchor.constraint(equalToConstant: 36.0),
            self.resizeIndicator.heightAnchor.constraint(equalToConstant: 5.0),
            self.resizeIndicator.centerXAnchor.constraint(equalTo: self.bottomSheetViewController.view.centerXAnchor),
            self.resizeIndicator.topAnchor.constraint(equalTo: self.bottomSheetViewController.view.topAnchor,
                                                      constant: 6.0)
        ])
    }
    
    func configureGesture() {
        self.bottomSheetViewController.view.addGestureRecognizer(self.panGesture)
    }
    
}
