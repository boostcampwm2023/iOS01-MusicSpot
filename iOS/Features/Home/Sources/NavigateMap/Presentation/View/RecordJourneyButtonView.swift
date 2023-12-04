//
//  RecordJourneyButtonView.swift
//
//
//  Created by 윤동주 on 12/2/23.
//

import UIKit
import MSUIKit
import MSDesignSystem

public final class RecordJourneyButtonView: UIView {
    
    // MARK: - Properties

    public var stackButtonView: RecordingJourneyButtonStackView = {
        let buttonView = RecordingJourneyButtonStackView()
        
        return buttonView
    }()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions

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
        self.configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    private func configureLayout() {
        self.axis = .horizontal
        self.spacing = 50
        self.alignment = .center
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addArrangedSubview(backButton)
        self.addArrangedSubview(spotButton)
        self.addArrangedSubview(nextButton)
        
    }
    
}
