//
//  SongListCell.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.03.
//

import UIKit

import MSDesignSystem
import MSExtension
import MSImageFetcher

public final class SongListCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    public static let estimatedHeight: CGFloat = 68.0
    
    private enum Metric {
        
        static let horizontalInset: CGFloat = 4.0
        static let horizontalSpacing: CGFloat = 12.0
        static let albumArtImageViewSize: CGFloat = 52.0
        static let albumArtImageViewCornerRadius: CGFloat = 5.0
        static let songInfoStackSpacing: CGFloat = 4.0
        static let rightIconImageViewSize: CGFloat = 24.0
        
    }
    
    // MARK: - UI Components
    
    private let albumArtImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Metric.albumArtImageViewCornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .msColor(.musicSpot)
        return imageView
    }()
    
    private let songInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.songInfoStackSpacing
        return stackView
    }()
    
    private let songTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.paragraph)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Title"
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = "Artist"
        return label
    }()
    
    private let rightIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.arrowRight)
        imageView.tintColor = .msColor(.primaryTypo)
        return imageView
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
    
    // MARK: - Life Cycle
    
    public override func prepareForReuse() {
        self.albumArtImageView.image = nil
    }
    
    // MARK: - Functions
    
    public func update(with cellModel: SongListCellModel) {
        self.songTitleLabel.text = cellModel.title
        self.artistLabel.text = cellModel.artist
        
        guard let albumArtURL = cellModel.albumArtURL else { return }
        self.albumArtImageView.ms.setImage(with: albumArtURL, forKey: albumArtURL.paath())
    }
    
}

// MARK: - UI Configuration

private extension SongListCell {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.primaryBackground)
    }
    
    func configureLayout() {
        [
            self.albumArtImageView,
            self.songInfoStack,
            self.rightIconImageView
        ].forEach {
            self.addSubview($0)
        }
        
        self.albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumArtImageView.widthAnchor.constraint(equalToConstant: Metric.albumArtImageViewSize),
            self.albumArtImageView.heightAnchor.constraint(equalToConstant: Metric.albumArtImageViewSize),
            self.albumArtImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.albumArtImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                            constant: Metric.horizontalInset)
        ])
        
        self.songInfoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.songInfoStack.leadingAnchor.constraint(equalTo: self.albumArtImageView.trailingAnchor,
                                                        constant: Metric.horizontalSpacing),
            self.songInfoStack.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        self.rightIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.rightIconImageView.widthAnchor.constraint(equalToConstant: Metric.rightIconImageViewSize),
            self.rightIconImageView.heightAnchor.constraint(equalToConstant: Metric.rightIconImageViewSize),
            self.rightIconImageView.leadingAnchor.constraint(equalTo: self.songInfoStack.trailingAnchor,
                                                             constant: Metric.horizontalSpacing),
            self.rightIconImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                              constant: Metric.horizontalInset),
            self.rightIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        [
            self.songTitleLabel,
            self.artistLabel
        ].forEach {
            self.songInfoStack.addArrangedSubview($0)
        }
    }
    
}

// MARK: - Preview

#if DEBUG
@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 345.0, height: 68.0)) {
    MSFont.registerFonts()
    
    let cell = SongListCell()
    NSLayoutConstraint.activate([
        cell.widthAnchor.constraint(equalToConstant: 345.0),
        cell.heightAnchor.constraint(equalToConstant: 68.0)
    ])
    
    return cell
}
#endif
