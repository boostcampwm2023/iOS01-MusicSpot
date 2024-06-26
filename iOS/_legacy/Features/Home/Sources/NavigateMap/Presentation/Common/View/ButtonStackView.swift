//
//  ButtonStackView.swift
//  Home
//
//  Created by 윤동주 on 11/22/23.
//

import UIKit

import MSUIKit

public protocol ButtonStackViewDelegate: AnyObject {
    func mapButtonDidTap()
    func userLocationButtonDidTap()
}

/// HomeMap 내 3개 버튼 StackView
final class ButtonStackView: UIStackView {
    // MARK: - Constants
    
    private enum Metric {
        static let spacing: CGFloat = 4.0
    }
    
    // MARK: - UI Components
    
    private let mapButton: MSRectButton = {
        let button = MSRectButton.small()
        button.image = .msIcon(.map)
        return button
    }()
    
    private let userLocationButton: MSRectButton = {
        let button = MSRectButton.small()
        button.image = .msIcon(.location)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: ButtonStackViewDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
        self.configureAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyles() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = Metric.spacing
    }
    
    private func configureLayout() {
        [
            self.mapButton,
            self.userLocationButton
        ].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    // MARK: - Configure: Action
    
    private func configureAction() {
        self.configureMapButtonAction()
        self.configureLocationButtonAction()
    }
    
    private func configureMapButtonAction() {
        let mapButtonAction = UIAction { [weak self] _ in
            self?.delegate?.mapButtonDidTap()
        }
        self.mapButton.addAction(mapButtonAction, for: .touchUpInside)
    }
    
    private func configureLocationButtonAction() {
        let userLocationButtonAction = UIAction { [weak self] _ in
            self?.delegate?.userLocationButtonDidTap()
        }
        self.userLocationButton.addAction(userLocationButtonAction, for: .touchUpInside)
    }
}
