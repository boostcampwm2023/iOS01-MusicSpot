//
//  JourneyInfoHeaderView.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

import MSDesignSystem

final class JourneyInfoHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    
    private enum Metric {
        static let contentSpacing: CGFloat = 5.0
        static let labelStackSpacing: CGFloat = 4.0
        static let subLabelStackSpacing: CGFloat = 8.0
    }
    
    // MARK: - UI Components
    
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.contentSpacing
        return stackView
    }()
    
    private let titleLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.labelStackSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private let subLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.subLabelStackSpacing
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.subtitle)
        label.textColor = .msColor(.primaryTypo)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "여정 위치"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.text = "2023. 01. 01"
        return label
    }()
    
    private let w3wLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = "하늘.사다.비싼"
        return label
    }()
    
    private let musicInfoView = MusicInfoView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    func update(with journey: Journey) {
        self.titleLabel.text = journey.locatoin
        self.dateLabel.text = journey.date
        self.w3wLabel.text = nil
    }
    
}

// MARK: - UI Configuration

private extension JourneyInfoHeaderView {
    
    func configureLayout() {
        self.addSubview(self.contentStack)
        self.contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.contentStack.topAnchor.constraint(equalTo: self.topAnchor,
                                                   constant: 20.0),
            self.contentStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.contentStack.addArrangedSubview(self.titleLabelStack)
        self.contentStack.addArrangedSubview(self.musicInfoView)
        
        self.titleLabelStack.addArrangedSubview(self.titleLabel)
        self.titleLabelStack.addArrangedSubview(self.subLabelStack)
        
        self.subLabelStack.addArrangedSubview(self.dateLabel)
        self.subLabelStack.addArrangedSubview(self.w3wLabel)
    }
    
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 341.0, height: 73.0)) {
    MSFont.registerFonts()
    let header = JourneyInfoHeaderView()
    return header
}
