//
//  MSUIComponents.swift
//  MSUIKit
//
//  Created by 이창준 on 11/14/23.
//

import UIKit

import MSDesignSystem
import MSLogger

// MARK: - MSBottomSheetViewController

open class MSBottomSheetViewController<Content: UIViewController, BottomSheet: UIViewController>
    : UIViewController, UIGestureRecognizerDelegate
{

    // MARK: Lifecycle

    // MARK: - Initializer

    public init(
        contentViewController: Content,
        bottomSheetViewController: BottomSheet)
    {
        self.contentViewController = contentViewController
        self.bottomSheetViewController = bottomSheetViewController
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Open

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureStyle()
        configureLayout()
        configureGesture()
    }

    // MARK: - Functions

    open func stateDidChanged(_ state: State) {
        MSLogger.make(category: .uiKit).log("Bottom Sheet 상태가 \(state.rawValue)로 업데이트 되었습니다.")

        if case .full = state {
            resizeIndicator.isHidden = true
        }
    }

    // MARK: Public

    // MARK: - State

    public enum State: String {
        case full
        case detented
        case minimized
    }

    // MARK: - UI Components

    public let contentViewController: Content
    public let bottomSheetViewController: BottomSheet

    // MARK: - Properties

    public var configuration: MSBottomSheetViewController.Configuration?

    public var state: State = .minimized {
        willSet { stateDidChanged(newValue) }
    }

    public func hideBottomSheet(animated: Bool = true) {
        topConstraints?.constant = .zero

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: .zero,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut])
            {
                self.view.layoutIfNeeded()
            }
        } else {
            view.layoutIfNeeded()
        }
    }

    public func showBottomSheet(animated: Bool = true) {
        guard let configuration else { return }
        topConstraints?.constant = -configuration.minimizedHeight

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: .zero,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut])
            {
                self.view.layoutIfNeeded()
                self.state = .minimized
            }
        } else {
            view.layoutIfNeeded()
            state = .minimized
        }
    }

    // MARK: Private

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

    private let gestureVelocity: CGFloat = 750.0

    private func presentFullBottomSheet(animated: Bool = true) {
        guard let configuration else { return }
        topConstraints?.constant = -configuration.fullHeight

        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .full
            }
        } else {
            view.layoutIfNeeded()
            state = .full
        }
    }

    private func presentDetentedBottomSheet(animated: Bool = true) {
        guard let configuration else { return }
        topConstraints?.constant = -configuration.detentHeight

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: .zero,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut])
            {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .detented
            }
        } else {
            view.layoutIfNeeded()
            state = .detented
        }
    }

    private func dismissBottomSheet(animated: Bool = true) {
        guard let configuration else { return }
        topConstraints?.constant = -configuration.minimizedHeight

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: .zero,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.5,
                options: [.curveEaseInOut])
            {
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.state = .minimized
            }
        } else {
            view.layoutIfNeeded()
            state = .minimized
        }
    }

    // MARK: - Pan Gesture

    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: bottomSheetViewController.view)
        let velocity = sender.velocity(in: bottomSheetViewController.view)

        switch sender.state {
        case .began, .changed:
            handlePanChanged(translation: translation)
        case .ended:
            handlePanEnded(translation: translation, velocity: velocity)
        case .failed:
            handlePanFailed()
        default: break
        }
    }

    private func handlePanChanged(translation: CGPoint) {
        guard let configuration else { return }

        resizeIndicator.isHidden = false

        switch state {
        case .full:
            guard translation.y > 0 else { return }

            topConstraints?.constant = -(configuration.fullHeight - translation.y.magnitude)
            view.layoutIfNeeded()

        case .detented:
            if translation.y >= 0 { // 아래로 Pan
                topConstraints?.constant = -(configuration.detentHeight - translation.y.magnitude)
            } else if translation.y < 0 { // 위로 Pan
                topConstraints?.constant = -(configuration.detentHeight + translation.y.magnitude)
            }
            view.layoutIfNeeded()

        case .minimized:
            guard translation.y < 0 else { return }

            let newConstant = -(configuration.minimizedHeight + translation.y.magnitude)
            topConstraints?.constant = newConstant
            view.layoutIfNeeded()
        }
    }

    private func handlePanEnded(translation: CGPoint, velocity: CGPoint) {
        guard let configuration else { return }

        let yTransMagnitude = translation.y.magnitude
        switch state {
        case .full:
            if velocity.y < 0 {
                presentFullBottomSheet()
            } else if yTransMagnitude >= configuration.fullDetentDiff / 2 || velocity.y > gestureVelocity {
                presentDetentedBottomSheet()
            } else {
                presentFullBottomSheet()
            }

        case .detented:
            if translation.y <= -configuration.fullDetentDiff / 2 || velocity.y < -gestureVelocity {
                presentFullBottomSheet()
            } else if translation.y >= configuration.detentMinimizedDiff / 2 || velocity.y > gestureVelocity {
                dismissBottomSheet()
            } else {
                presentDetentedBottomSheet()
            }

        case .minimized:
            if yTransMagnitude >= configuration.detentHeight / 2 || velocity.y < -gestureVelocity {
                presentDetentedBottomSheet()
            } else {
                dismissBottomSheet()
            }
        }
    }

    private func handlePanFailed() {
        switch state {
        case .full:
            presentFullBottomSheet()
        case .detented:
            presentDetentedBottomSheet()
        case .minimized:
            dismissBottomSheet()
        }
    }
}

// MARK: - UI Configuration

extension MSBottomSheetViewController {
    private func configureStyle() {
        bottomSheetViewController.view.layer.cornerRadius = 12.0
        bottomSheetViewController.view.clipsToBounds = true

        configuration?.standardMetric = view.frame.height
    }

    private func configureLayout() {
        guard let configuration else { return }

        addChild(contentViewController)
        addChild(bottomSheetViewController)

        view.addSubview(contentViewController.view)
        view.addSubview(bottomSheetViewController.view)

        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            contentViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        contentViewController.didMove(toParent: self)

        bottomSheetViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSheetViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomSheetViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        topConstraints = bottomSheetViewController.view.topAnchor
            .constraint(
                equalTo: view.bottomAnchor,
                constant: -configuration.minimizedHeight)
        topConstraints?.isActive = true
        bottomSheetViewController.didMove(toParent: self)

        bottomSheetViewController.view.addSubview(resizeIndicator)
        resizeIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resizeIndicator.widthAnchor.constraint(equalToConstant: 36.0),
            resizeIndicator.heightAnchor.constraint(equalToConstant: 5.0),
            resizeIndicator.centerXAnchor.constraint(equalTo: bottomSheetViewController.view.centerXAnchor),
            resizeIndicator.topAnchor.constraint(
                equalTo: bottomSheetViewController.view.topAnchor,
                constant: 6.0),
        ])
    }

    private func configureGesture() {
        bottomSheetViewController.view.addGestureRecognizer(panGesture)
    }
}
