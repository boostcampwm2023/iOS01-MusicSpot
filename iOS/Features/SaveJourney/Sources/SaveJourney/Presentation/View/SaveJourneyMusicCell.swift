//
//  SaveJourneyMusicCell.swift
//  SaveJourney
//
//  Created by 이창준 on 11/25/23.
//

import UIKit

import MSDesignSystem

final class SaveJourneyMusicCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum Metric {
        static let cornerRadius: CGFloat = 12.0
        static let imageViewCornerRadius: CGFloat = 5.0
        static let imageViewSize: CGFloat = 128.0
        static let stackViewSpacing: CGFloat = 4.0
        static let iconImageSize: CGFloat = 24.0
    }
    
    // MARK: - UI Components
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Metric.imageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        return stackView
    }()
    
    private let audioIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.voice)
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.boldCaption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Super Shy"
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Super Shy"
        return label
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    func update(with data: String) {
        
    }
    
}

// MARK: - UI Configuration

private extension SaveJourneyMusicCell {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.componentBackground)
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
    func configureLayout() {
        self.addSubview(self.albumArtImageView)
        self.albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumArtImageView.widthAnchor.constraint(equalToConstant: Metric.imageViewSize),
            self.albumArtImageView.heightAnchor.constraint(equalToConstant: Metric.imageViewSize)
        ])
        
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.albumArtImageView.topAnchor),
            self.stackView.leadingAnchor.constraint(equalTo: self.albumArtImageView.trailingAnchor,
                                                    constant: 12.0),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                     constant: 12.0)
        ])
        
        [
            self.audioIconImageView,
            self.titleLabel,
            self.artistLabel
        ].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        self.audioIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.audioIconImageView.widthAnchor.constraint(equalToConstant: Metric.iconImageSize),
            self.audioIconImageView.heightAnchor.constraint(equalToConstant: Metric.iconImageSize)
        ])
    }
    
}
