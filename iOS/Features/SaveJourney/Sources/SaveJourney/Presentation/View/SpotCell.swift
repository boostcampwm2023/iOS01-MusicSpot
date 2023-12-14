//
//  SpotCell.swift
//  SaveJourney
//
//  Created by 이창준 on 2023.12.04.
//

import UIKit

import MSDesignSystem
import MSExtension
import MSImageFetcher

final class SpotCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let cornerRadius: CGFloat = 5.0
        static let labelStackHorizontalSpacing: CGFloat = 8.0
        static let labelStackVerticalSpacing: CGFloat = 5.0
        
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .msColor(.componentBackground)
        return imageView
    }()
    
    private let labelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.boldCaption)
        label.textColor = .msColor(.primaryTypo)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    @MainActor
    func update(with cellModel: SpotCellModel) {
        self.locationLabel.text = cellModel.location
        self.dateLabel.text = cellModel.date.formatted(date: .abbreviated, time: .omitted)
        self.imageView.ms.setImage(with: cellModel.photoURL,
                                   forKey: cellModel.photoURL.paath())
    }
    
}

private extension SpotCell {
    
    func configureStyles() {
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
    func configureLayout() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        self.imageView.addSubview(self.labelStack)
        self.labelStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.labelStack.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor,
                                                     constant: Metric.labelStackHorizontalSpacing),
            self.labelStack.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor,
                                                    constant: -Metric.labelStackVerticalSpacing),
            self.labelStack.trailingAnchor.constraint(lessThanOrEqualTo: self.imageView.trailingAnchor)
        ])
        
        [
            self.locationLabel,
            self.dateLabel
        ].forEach {
            self.labelStack.addArrangedSubview($0)
        }
    }
    
}
