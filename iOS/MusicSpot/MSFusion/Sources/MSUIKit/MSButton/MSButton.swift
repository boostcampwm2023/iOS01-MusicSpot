//
//  MSButton.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

// MARK: - MSButton

public class MSButton: UIButton {

    // MARK: Lifecycle

    // MARK: - Initializer

    private override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
        configureLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Public

    public enum CornerStyle {
        case squared
        case rounded
        case custom(CGFloat)

        var cornerRadius: CGFloat {
            switch self {
            case .squared: 8.0
            case .rounded: 25.0
            case .custom(let cornerRadius): cornerRadius
            }
        }
    }

    // MARK: - Properties

    public var title: String? {
        didSet { configureTitle(title) }
    }

    public var image: UIImage? {
        didSet { configureIcon(image) }
    }

    public var cornerStyle: CornerStyle = .squared {
        didSet { configureCornerStyle(cornerStyle) }
    }

    // MARK: Internal

    var haptic: UIFeedbackGenerator?

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let height: CGFloat = 60.0
        static let horizontalEdgeInsets: CGFloat = 58.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imagePadding: CGFloat = 8.0
    }

    // MARK: - UI Configuration

    private func configureStyles() {
        var configuration = UIButton.Configuration.filled()
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Metric.verticalEdgeInsets,
            leading: Metric.horizontalEdgeInsets,
            bottom: Metric.verticalEdgeInsets,
            trailing: Metric.horizontalEdgeInsets)
        configuration.imagePlacement = .leading
        configuration.imagePadding = Metric.imagePadding
        configuration.titleAlignment = .center
        configuration.titleLineBreakMode = .byTruncatingMiddle
        self.configuration = configuration
    }

    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
        ])
    }
}

// MARK: - Private Configuration Functions

extension MSButton {
    private func configureTitle(_ title: String?) {
        var container = AttributeContainer()
        container.font = .msFont(.buttonTitle)
        configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
    }

    private func configureIcon(_ icon: UIImage?) {
        configuration?.image = icon
    }

    private func configureCornerStyle(_ cornerStyle: CornerStyle) {
        layer.cornerRadius = cornerStyle.cornerRadius
        clipsToBounds = true
    }
}
