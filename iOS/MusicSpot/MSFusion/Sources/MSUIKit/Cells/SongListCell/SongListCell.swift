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

// MARK: - SongListCell

public final class SongListCell: UICollectionViewCell {

    // MARK: Lifecycle

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
        configureLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Public

    // MARK: - Constants

    public static let estimatedHeight: CGFloat = 68.0

    public override func prepareForReuse() {
        albumArtImageView.image = nil
    }

    // MARK: - Functions

    public func update(with cellModel: SongListCellModel) {
        songTitleLabel.text = cellModel.title
        artistLabel.text = cellModel.artist

        guard let albumArtURL = cellModel.albumArtURL else { return }
        albumArtImageView.ms.setImage(with: albumArtURL, forKey: albumArtURL.paath())
    }

    // MARK: Private

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

}

// MARK: - UI Configuration

extension SongListCell {
    private func configureStyles() {
        backgroundColor = .msColor(.primaryBackground)
    }

    private func configureLayout() {
        [
            albumArtImageView,
            songInfoStack,
            rightIconImageView,
        ].forEach {
            self.addSubview($0)
        }

        albumArtImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumArtImageView.widthAnchor.constraint(equalToConstant: Metric.albumArtImageViewSize),
            albumArtImageView.heightAnchor.constraint(equalToConstant: Metric.albumArtImageViewSize),
            albumArtImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumArtImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metric.horizontalInset),
        ])

        songInfoStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            songInfoStack.leadingAnchor.constraint(
                equalTo: albumArtImageView.trailingAnchor,
                constant: Metric.horizontalSpacing),
            songInfoStack.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        rightIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightIconImageView.widthAnchor.constraint(equalToConstant: Metric.rightIconImageViewSize),
            rightIconImageView.heightAnchor.constraint(equalToConstant: Metric.rightIconImageViewSize),
            rightIconImageView.leadingAnchor.constraint(
                equalTo: songInfoStack.trailingAnchor,
                constant: Metric.horizontalSpacing),
            rightIconImageView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Metric.horizontalInset),
            rightIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        [
            songTitleLabel,
            artistLabel,
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
        cell.heightAnchor.constraint(equalToConstant: 68.0),
    ])

    return cell
}
#endif
