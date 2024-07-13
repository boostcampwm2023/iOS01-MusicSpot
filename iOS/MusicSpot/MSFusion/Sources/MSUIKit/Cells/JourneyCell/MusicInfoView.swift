//
//  MusicInfoView.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

// MARK: - MusicInfoView

final class MusicInfoView: UIView {

    // MARK: Lifecycle

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Internal

    // MARK: - Functions

    func update(artist: String?, title: String?) {
        artistLabel.text = artist
        titleLabel.text = title
    }

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let spacing: CGFloat = 8.0
        static let iconSize: CGFloat = 24.0
    }

    // MARK: - UI Components

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.spacing
        return stackView
    }()

    private let musicInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.voice)
        imageView.tintColor = .msColor(.primaryTypo)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.boldCaption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Title"
        return label
    }()

    private let dividerLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "・"
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.primaryTypo)
        label.text = "Artist"
        return label
    }()

}

// MARK: - UI Configuration

extension MusicInfoView {
    private func configureLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        [
            Spacer(.horizontal),
            iconImageView,
            musicInfoStackView,
        ].forEach {
            self.stackView.addArrangedSubview($0)
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: Metric.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Metric.iconSize),
        ])

        [
            titleLabel,
            dividerLabel,
            artistLabel,
        ].forEach {
            self.musicInfoStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Preview

import MSDesignSystem
@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 341.0, height: 24.0)) {
    MSFont.registerFonts()
    return MusicInfoView()
}
