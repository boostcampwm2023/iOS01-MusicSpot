//
//  JourneyInfoView.swift
//  MSUIKit
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

import MSDesignSystem

// MARK: - JourneyInfoView

final class JourneyInfoView: UIView {

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

    func update(
        location: String,
        date: Date,
        w3w: String = "",
        title: String?,
        artist: String?)
    {
        titleLabel.text = location
        dateLabel.text = date.formatted(date: .abbreviated, time: .omitted)
        w3wLabel.text = w3w
        if let title, let artist {
            musicInfoView.update(artist: artist, title: title)
            musicInfoView.isHidden = false
        } else {
            musicInfoView.isHidden = true
        }
    }

    // MARK: Private

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

}

// MARK: - UI Configuration

extension JourneyInfoView {
    private func configureLayout() {
        addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        contentStack.addArrangedSubview(titleLabelStack)
        contentStack.addArrangedSubview(musicInfoView)

        titleLabelStack.addArrangedSubview(titleLabel)
        titleLabelStack.addArrangedSubview(subLabelStack)

        subLabelStack.addArrangedSubview(dateLabel)
        subLabelStack.addArrangedSubview(w3wLabel)
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 341.0, height: 73.0)) {
    MSFont.registerFonts()
    return JourneyInfoView()
}
