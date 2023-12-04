//
//  RecordJourneyButtonView.swift
//
//
//  Created by 윤동주 on 12/2/23.
//

import UIKit
import MSUIKit
import MSDesignSystem
public protocol RecordJourneyButtonViewDelegate {
    func backButtonDidTap()
    func spotButtonDidTap()
    func nextButtonDidTap()
}

public final class RecordJourneyButtonView: UIView {
    
    // MARK: - Properties

    public var stackButtonView: RecordingJourneyButtonStackView = {
        let buttonView = RecordingJourneyButtonStackView()
        
        return buttonView
    }()
    
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
    
    private func configureStyle() {
        
    }
    
    private func configureLayout() {
        self.addSubview(stackButtonView)
        self.stackButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackButtonView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 0),
            stackButtonView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 0),
            stackButtonView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0)
        ])
    }
    
    
    // MARK: - Configure: Action
    
    private func configureAction() {
        configureBackButtonAction()
        configureSpotButtonAction()
        configureNextButtonAction()
    }
    
    private func configureBackButtonAction() {
        let backButtonAction = UIAction(handler: { _ in
            self.backButtonDidTap()
        })
        self.stackButtonView.backButton.addAction(backButtonAction, for: .touchUpInside)
    }
    
    private func configureSpotButtonAction() {
        let spotButtonAction = UIAction(handler: { _ in
            self.spotButtonDidTap()
        })
        self.stackButtonView.spotButton.addAction(spotButtonAction, for: .touchUpInside)
    }
    
    private func configureNextButtonAction() {
        let nextButtonAction = UIAction(handler: { _ in
            self.nextButtonDidTap()
        })
        self.stackButtonView.nextButton.addAction(nextButtonAction, for: .touchUpInside)
    }
    
    // MARK: - Functions

    private func backButtonDidTap() {
        self.delegate?.backButtonDidTap()
    }
    
    private func spotButtonDidTap() {
        self.delegate?.spotButtonDidTap()
    }
    
    private func nextButtonDidTap() {
        self.delegate?.nextButtonDidTap()
    }
}

final public class RecordingJourneyButtonStackView: UIStackView {
    
    // MARK: - Properties

    public var backButton: MSRectButton = {
        let button = MSRectButton.small(isBrandColored: false)
        button.image = .msIcon(.arrowLeft)
        return button
    }()
    
    public var spotButton: MSRectButton = {
        let button = MSRectButton.large(isBrandColored: true)
        button.title = "스팟!"
        return button
    }()
    
    public var nextButton: MSRectButton = {
        let button = MSRectButton.small(isBrandColored: false)
        button.image = .msIcon(.check)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyle()
        self.configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyle() {
        
    }
    
    private func configureLayout() {
        
        self.addArrangedSubview(backButton)
        self.addArrangedSubview(spotButton)
        self.addArrangedSubview(nextButton)
        
        self.axis = .horizontal
        self.spacing = 50
        self.alignment = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
