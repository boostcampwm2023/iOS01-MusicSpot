//
//  JourneyListHeaderView.swift
//  JourneyList
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

import MSDesignSystem
import MSUIKit

public final class JourneyListHeaderView: UICollectionReusableView {
    
    // MARK: - Constants
    
    static let estimatedHight: CGFloat = 46.0 + Metric.verticalInset
    
    private enum Typo {
        
        static let title: String = "지난 여정"
        static func subtitle(numberOfJourneys: Int) -> String {
            return "현재 위치에 \(numberOfJourneys)개의 여정이 있습니다."
        }
        
    }
    
    private enum Metric {
        
        static let titleStackSpacing: CGFloat = 4.0
        static let horizontalInset: CGFloat = 16.0
        static let verticalInset: CGFloat = 24.0
        
    }
    
    // MARK: - UI Components
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.titleStackSpacing
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.headerTitle)
        label.textColor = .msColor(.primaryTypo)
        label.text = Typo.title
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = Typo.subtitle(numberOfJourneys: 0)
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    func update(numberOfJourneys: Int) {
        self.subtitleLabel.text = Typo.subtitle(numberOfJourneys: numberOfJourneys)
    }
    
}

// MARK: - UI Configuration

private extension JourneyListHeaderView {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        self.addSubview(self.titleStack)
        
        [
            self.titleLabel,
            self.subtitleLabel
        ].forEach {
            self.titleStack.addArrangedSubview($0)
        }
        self.titleStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: JourneyListHeaderView.estimatedHight),
            
            self.titleStack.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleStack.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: Metric.horizontalInset),
            self.titleStack.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor,
                                                    constant: -Metric.verticalInset),
            self.titleStack.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: Metric.horizontalInset)
        ])
    }
    
}
