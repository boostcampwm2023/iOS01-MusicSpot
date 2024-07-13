//
//  MSAlertViewController.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

import MSDesignSystem

open class MSAlertViewController: UIViewController {

    // MARK: Open

    // MARK: - Properties

    open var cancelButtonAction: UIAction? {
        didSet {
            guard let action = cancelButtonAction else { return }
            cancelButton.addAction(action, for: .touchUpInside)
        }
    }

    open var doneButtonAction: UIAction? {
        didSet {
            guard let action = doneButtonAction else { return }
            doneButton.addAction(action, for: .touchUpInside)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        configureStyles()
        configureLayout()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePresentView()
    }

    // MARK: - Helpers

    @objc
    open func dismissBottomSheet() {
        animateDismissView()
    }

    // MARK: - UI Configuration

    open func configureStyles() {
        view.backgroundColor = .clear
        dimmedView.addGestureRecognizer(tapGesture)
        containerView.addGestureRecognizer(panGesture)
    }

    open func configureLayout() {
        configureSubviews()
        configureConstraints()
    }

    // MARK: Public

    // MARK: - UI Components

    /// Base
    public let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .msColor(.modalBackground)
        view.layer.cornerRadius = Metric.containerViewCornerRadius
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Functions

    public func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    public func updateSubtitle(_ subtitle: String) {
        subtitleLabel.text = subtitle
    }

    public func updateDoneButton(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }

    public func updateDoneButtonLoadingState(to isLoading: Bool) {
        doneButton.configuration?.showsActivityIndicator = isLoading
    }

    // MARK: Private

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

    /// Title
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

    /// Button
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
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: Metric.cancelButtonVerticalInset,
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

    /// Gesture
    private lazy var tapGesture = UITapGestureRecognizer(
        target: self,
        action: #selector(self.dismissBottomSheet))

    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(self.handlePanGesture(_:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        return panGesture
    }()

    private var containerViewHeight: NSLayoutConstraint?
    private var containerViewBottomInset: NSLayoutConstraint?

    private var keyboardLayoutHeight: CGFloat {
        view.keyboardLayoutGuide.layoutFrame.height
    }

    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: containerView)
        let velocity = sender.velocity(in: containerView)
        let updatedBottomInset = Metric.verticalInset + translation.y

        switch sender.state {
        case .changed where updatedBottomInset > Metric.verticalInset:
            containerViewBottomInset?.constant = updatedBottomInset - keyboardLayoutHeight
            view.layoutIfNeeded()

        case .ended:
            if
                translation.y > Metric.bottomSheetHeight * (1 - Metric.dismissingHeightRatio)
                || velocity.y > Metric.gestureVelocity
            {
                animateDismissView()
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

        dimmedView.alpha = .zero
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = Metric.dimmedViewMaximumAlpha
        }
    }

    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomInset?.constant = Metric.bottomSheetHeight + self.keyboardLayoutHeight
            self.view.layoutIfNeeded()
        }

        dimmedView.alpha = Metric.dimmedViewMaximumAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = .zero
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }

    private func configureSubviews() {
        for item in [dimmedView, containerView] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        for item in [resizeIndicator, titleStack, buttonStack] {
            containerView.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        for item in [titleLabel, subtitleLabel] {
            titleStack.addArrangedSubview(item)
        }

        for item in [cancelButton, doneButton] {
            buttonStack.addArrangedSubview(item)
        }
    }

    private func configureConstraints() {
        let bottomInset = containerView.bottomAnchor.constraint(
            equalTo: view.keyboardLayoutGuide.topAnchor,
            constant: Metric.bottomSheetHeight)
        let heightConstraint = containerView.heightAnchor.constraint(equalToConstant: Metric.bottomSheetHeight)
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            containerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Metric.horizontalInset),
            bottomInset,
            containerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Metric.horizontalInset),
            heightConstraint,
        ])
        containerViewBottomInset = bottomInset
        containerViewHeight = heightConstraint

        NSLayoutConstraint.activate([
            resizeIndicator.widthAnchor.constraint(equalToConstant: Metric.ResizeIndicator.width),
            resizeIndicator.heightAnchor.constraint(equalToConstant: Metric.ResizeIndicator.height),
            resizeIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            resizeIndicator.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Metric.ResizeIndicator.topSpacing),

            titleStack.topAnchor.constraint(
                equalTo: containerView.topAnchor,
                constant: Metric.verticalInset),
            titleStack.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Metric.horizontalInset),
            titleStack.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Metric.horizontalInset),

            buttonStack.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: Metric.horizontalInset),
            buttonStack.bottomAnchor.constraint(
                equalTo: containerView.bottomAnchor,
                constant: -Metric.verticalInset / 2),
            buttonStack.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -Metric.horizontalInset),
        ])
    }

}
