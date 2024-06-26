//
//  SaveJourneyHeaderView.swift
//  SaveJourney
//
//  Created by 이창준 on 11/25/23.
//

import UIKit

import MSDesignSystem

final class SaveJourneyHeaderView: UICollectionReusableView {
    // MARK: - Constants
    
    static let elementKind = "SaveJourneyHeaderView"
    static let estimatedHeight: CGFloat = 33.0
    
    // MARK: - UI Components
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.duperTitle)
        label.textColor = .msColor(.primaryTypo)
        label.text = "헤더"
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    func update(with title: String) {
        self.titleLabel.text = title
    }
}

// MARK: - UI Configuration

private extension SaveJourneyHeaderView {
    func configureLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
