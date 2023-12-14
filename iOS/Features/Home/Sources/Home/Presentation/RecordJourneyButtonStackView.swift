//
//  RecordJourneyButtonView.swift
//  NavigateMap
//
//  Created by 윤동주 on 12/2/23.
//

import UIKit

import MSDesignSystem
import MSUIKit

public protocol RecordJourneyButtonViewDelegate: AnyObject {
    
    func backButtonDidTap(_ button: MSRectButton)
    func spotButtonDidTap(_ button: MSRectButton)
    func nextButtonDidTap(_ button: MSRectButton)
    
}

public final class RecordJourneyButtonStackView: UIView {
    
    // MARK: - Constants
    
    private enum Typo {
        
        static let spotButtonTitle = "스팟!"
        
    }
    
    private enum Metric {
        
        static let stackViewSpacing: CGFloat = 50.0
        
    }
    
    // MARK: - UI Components
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.stackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private let backButton: MSRectButton = {
        let button = MSRectButton.small(isBrandColored: false)
        button.image = .msIcon(.arrowLeft)
        return button
    }()
    
    private let spotButton: MSRectButton = {
        let button = MSRectButton.large(isBrandColored: true)
        button.title = Typo.spotButtonTitle
        return button
    }()
    
    private let nextButton: MSRectButton = {
        let button = MSRectButton.small(isBrandColored: false)
        button.image = .msIcon(.check)
        return button
    }()
    
    // MARK: - Properties
    
    public var delegate: RecordJourneyButtonViewDelegate?
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureStyle()
        self.configureLayout()
        self.configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyle() { }
    
    private func configureLayout() {
        self.addSubview(self.buttonStackView)
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.buttonStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        [
            self.backButton,
            self.spotButton,
            self.nextButton
        ].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
    }
    
    // MARK: - Action Configuration
    
    private func configureAction() {
        self.configureBackButtonAction()
        self.configureSpotButtonAction()
        self.configureNextButtonAction()
    }
    
    private func configureBackButtonAction() {
        let backButtonAction = UIAction { _ in
            self.backButtonDidTap()
        }
        self.backButton.addAction(backButtonAction, for: .touchUpInside)
    }
    
    private func configureSpotButtonAction() {
        let spotButtonAction = UIAction { _ in
            self.spotButtonDidTap()
        }
        self.spotButton.addAction(spotButtonAction, for: .touchUpInside)
    }
    
    private func configureNextButtonAction() {
        let nextButtonAction = UIAction { _ in
            self.nextButtonDidTap()
        }
        self.nextButton.addAction(nextButtonAction, for: .touchUpInside)
    }
    
    // MARK: - Functions

    private func backButtonDidTap() {
        self.delegate?.backButtonDidTap(self.backButton)
    }
    
    private func spotButtonDidTap() {
        self.delegate?.spotButtonDidTap(self.spotButton)
    }
    
    private func nextButtonDidTap() {
        self.delegate?.nextButtonDidTap(self.nextButton)
    }
    
}
