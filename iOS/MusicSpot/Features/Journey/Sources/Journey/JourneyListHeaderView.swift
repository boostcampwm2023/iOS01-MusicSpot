//
//  JourneyListHeaderView.swift
//  Journey
//
//  Created by 이창준 on 2023.12.02.
//

import UIKit

import MSDesignSystem
import MSUIKit

// MARK: - JourneyListHeaderView

public final class JourneyListHeaderView: UICollectionReusableView {

    // MARK: Lifecycle

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
        configureLayout()
    }

    public required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Internal

    // MARK: - Constants

    static let elementKind = "JourneyListHeaderView"
    static let estimatedHight: CGFloat = 46.0 + Metric.verticalInset

    // MARK: - Functions

    @MainActor
    func update(numberOfJourneys: Int) {
        subtitleLabel.text = Typo.subtitle(numberOfJourneys: numberOfJourneys)
    }

    // MARK: Private

    private enum Typo {
        static let title = "지난 여정"
        static func subtitle(numberOfJourneys: Int) -> String {
            "현재 위치에 \(numberOfJourneys)개의 여정이 있습니다."
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

}

// MARK: - UI Configuration

extension JourneyListHeaderView {
    private func configureStyles() {
        backgroundColor = .msColor(.primaryBackground)
    }

    private func configureLayout() {
        addSubview(titleStack)

        [
            titleLabel,
            subtitleLabel,
        ].forEach {
            self.titleStack.addArrangedSubview($0)
        }
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: JourneyListHeaderView.estimatedHight),

            titleStack.topAnchor.constraint(equalTo: topAnchor),
            titleStack.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metric.horizontalInset),
            titleStack.bottomAnchor.constraint(
                lessThanOrEqualTo: bottomAnchor,
                constant: -Metric.verticalInset),
            titleStack.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: Metric.horizontalInset),
        ])
    }
}
