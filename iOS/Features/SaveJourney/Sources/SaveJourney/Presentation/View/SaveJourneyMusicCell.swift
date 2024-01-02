//
//  SaveJourneyMusicCell.swift
//  SaveJourney
//
//  Created by 이창준 on 11/25/23.
//

import UIKit

import MSDesignSystem
import MSDomain

final class SaveJourneyMusicCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let estimatedHeight: CGFloat = 152.0
    
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
        imageView.backgroundColor = .msColor(.musicSpot)
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.stackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private let audioIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.voice)
        imageView.tintColor = .msColor(.primaryTypo)
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
        label.text = "NewJeans"
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
    
    func update(with cellModel: Music) {
        self.titleLabel.text = cellModel.title
        self.artistLabel.text = cellModel.artist
        
        guard let albumCoverURL = cellModel.albumCover?.url else { return }
        self.albumArtImageView.ms.setImage(with: albumCoverURL, forKey: cellModel.id)
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
            self.albumArtImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.albumArtImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: 12.0),
            self.albumArtImageView.widthAnchor.constraint(equalToConstant: Metric.imageViewSize),
            self.albumArtImageView.heightAnchor.constraint(equalToConstant: Metric.imageViewSize)
        ])
        
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
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
