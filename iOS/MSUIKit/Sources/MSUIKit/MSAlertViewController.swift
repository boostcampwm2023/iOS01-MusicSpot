//
//  MSAlertViewController.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

import MSDesignSystem

open class MSAlertViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let cancelButtonTitle = "취소"
        static let doneButtonTitle = "여정 완료"
        
    }
    
    private enum Metric {
        
        static let bottomSheetHeight: CGFloat = 294.0
        static let dismissingHeightRatio: CGFloat = 0.6
        static let dimmedViewMaximumAlpha: CGFloat = 0.6
        
        static let horizontalInset: CGFloat = 12.0
        static let verticalInset: CGFloat = 24.0
        static let containerViewCornerRadius: CGFloat = 12.0
        static let stackSpacing: CGFloat = 4.0
        
        static let cancelButtonVerticalInset: CGFloat = 10.0
        static let cancelButtonHorizontalInset: CGFloat = 28.0
        
        enum ResizeIndicator {
            static let width: CGFloat = 36.0
            static let height: CGFloat = 5.0
            static let topSpacing: CGFloat = 5.0
        }
        
        static let gestureVelocity: CGFloat = 750.0
        
    }
    
    // MARK: - UI Components
    
    // Base
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .msColor(.modalBackground)
        view.layer.cornerRadius = Metric.containerViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = .zero
        return view
    }()
    
    private let resizeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 2.5
        view.clipsToBounds = true
        return view
    }()
    
    // Title
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.headerTitle)
        label.textColor = .msColor(.primaryTypo)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        return label
    }()
    
    // Button
    private let buttonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackSpacing
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let cancelButton: MSButton = {
        let button = MSButton.secondary()
        button.cornerStyle = .squared
        button.title = Typo.cancelButtonTitle
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: Metric.cancelButtonVerticalInset,
                                                                      leading: Metric.cancelButtonHorizontalInset,
                                                                      bottom: Metric.cancelButtonVerticalInset,
                                                                      trailing: Metric.cancelButtonHorizontalInset)
        return button
    }()
    
    private let doneButton: MSButton = {
        let button = MSButton.primary()
        button.cornerStyle = .squared
        button.title = Typo.doneButtonTitle
        button.isEnabled = false
        return button
    }()
    
    // Gesture
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tagGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(self.dismissBottomSheet))
        return tagGesture
    }()
    
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(self.handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        return panGesture
    }()
    
    private var containerViewHeight: NSLayoutConstraint?
    private var containerViewBottomInset: NSLayoutConstraint?
    
    private var keyboardLayoutHeight: CGFloat {
        self.view.keyboardLayoutGuide.layoutFrame.height
    }
    
    // MARK: - Properties
    
    open var cancelButtonAction: UIAction? {
        didSet {
            guard let action = self.cancelButtonAction else { return }
            self.cancelButton.addAction(action, for: .touchUpInside)
        }
    }
    
    open var doneButtonAction: UIAction? {
        didSet {
            guard let action = self.doneButtonAction else { return }
            self.doneButton.addAction(action, for: .touchUpInside)
        }
    }
    
    // MARK: - Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configureStyles()
        self.configureLayout()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.animatePresentView()
    }
    
    // MARK: - Helpers
    
    @objc
    open func dismissBottomSheet() {
        self.animateDismissView()
    }
    
    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.containerView)
        let velocity = sender.velocity(in: self.containerView)
        let updatedBottomInset = Metric.verticalInset + translation.y
        
        switch sender.state {
        case .changed where updatedBottomInset > Metric.verticalInset:
            self.containerViewBottomInset?.constant = updatedBottomInset - self.keyboardLayoutHeight
            self.view.layoutIfNeeded()
        case .ended:
            if translation.y > Metric.bottomSheetHeight * (1 - Metric.dismissingHeightRatio)
                || velocity.y > Metric.gestureVelocity {
                self.animateDismissView()
            } else {
                UIView.animate(withDuration: 0.4) {
                    self.containerViewBottomInset?.constant = Metric.verticalInset - self.keyboardLayoutHeight
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    private func animatePresentView() {
        UIView.animate(withDuration: 0.3, delay: .zero, options: .curveEaseInOut) {
            self.containerViewBottomInset?.constant = -Metric.verticalInset / 2
            self.view.layoutIfNeeded()
        }
        
        self.dimmedView.alpha = .zero
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = Metric.dimmedViewMaximumAlpha
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomInset?.constant = Metric.bottomSheetHeight + self.keyboardLayoutHeight
            self.view.layoutIfNeeded()
        }
        
        self.dimmedView.alpha = Metric.dimmedViewMaximumAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = .zero
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: - UI Configuration
    
    open func configureStyles() {
        self.view.backgroundColor = .clear
        self.dimmedView.addGestureRecognizer(self.tapGesture)
        self.containerView.addGestureRecognizer(self.panGesture)
    }
    
    open func configureLayout() {
        self.configureSubviews()
        self.configureConstraints()
    }
    
    private func configureSubviews() {
        [self.dimmedView, self.containerView].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [self.resizeIndicator, self.titleStack, self.buttonStack].forEach {
            self.containerView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [self.titleLabel, self.subtitleLabel].forEach {
            self.titleStack.addArrangedSubview($0)
        }
        
        [self.cancelButton, self.doneButton].forEach {
            self.buttonStack.addArrangedSubview($0)
        }
    }
    
    private func configureConstraints() {
        let bottomInset = self.containerView.bottomAnchor.constraint(equalTo: self.view.keyboardLayoutGuide.topAnchor,
                                                                     constant: Metric.bottomSheetHeight)
        let heightConstraint = self.containerView.heightAnchor.constraint(equalToConstant: Metric.bottomSheetHeight)
        NSLayoutConstraint.activate([
            self.dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                        constant: Metric.horizontalInset),
            bottomInset,
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                         constant: -Metric.horizontalInset),
            heightConstraint
        ])
        self.containerViewBottomInset = bottomInset
        self.containerViewHeight = heightConstraint
        
        NSLayoutConstraint.activate([
            self.resizeIndicator.widthAnchor.constraint(equalToConstant: Metric.ResizeIndicator.width),
            self.resizeIndicator.heightAnchor.constraint(equalToConstant: Metric.ResizeIndicator.height),
            self.resizeIndicator.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.resizeIndicator.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                      constant: Metric.ResizeIndicator.topSpacing),
            
            self.titleStack.topAnchor.constraint(equalTo: self.containerView.topAnchor,
                                                 constant: Metric.verticalInset),
            self.titleStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                     constant: Metric.horizontalInset),
            self.titleStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                      constant: -Metric.horizontalInset),
            
            self.buttonStack.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor,
                                                      constant: Metric.horizontalInset),
            self.buttonStack.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor,
                                                     constant: -Metric.verticalInset / 2),
            self.buttonStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor,
                                                       constant: -Metric.horizontalInset)
        ])
    }
    
    // MARK: - Functions
    
    public func updateTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    public func updateSubtitle(_ subtitle: String) {
        self.subtitleLabel.text = subtitle
    }
    
    public func updateDoneButton(isEnabled: Bool) {
        self.doneButton.isEnabled = isEnabled
    }
    
}
