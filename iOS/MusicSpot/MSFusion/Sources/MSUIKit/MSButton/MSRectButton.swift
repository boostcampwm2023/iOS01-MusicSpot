//
//  MSRectButton.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

// MARK: - MSRectButton

public final class MSRectButton: UIButton {

    // MARK: Lifecycle

    // MARK: - Initializer

    private override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
        configureLayout()
        haptic.prepare()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Public

    // MARK: - Properties

    public var title: String? {
        didSet { configureTitle(title) }
    }

    public var image: UIImage? {
        didSet { configureIcon(image) }
    }

    // MARK: Internal

    enum Style {
        case small
        case large

        var size: CGSize {
            switch self {
            case .small: CGSize(width: 52.0, height: 56.0)
            case .large: CGSize(width: 120.0, height: 120.0)
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: 8.0
            case .large: 30.0
            }
        }
    }

    var style: Style = .small {
        didSet {
            configureSize(by: style)
            configureCornerStyle(by: style)
        }
    }

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let edgeInsets: CGFloat = 10.0
    }

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - UI Configuration

    private func configureStyles() {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .msColor(.primaryTypo)
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Metric.edgeInsets,
            leading: Metric.edgeInsets,
            bottom: Metric.edgeInsets,
            trailing: Metric.edgeInsets)
        configuration.imagePlacement = .leading
        configuration.titleAlignment = .center
        self.configuration = configuration

        configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                self.haptic.impactOccurred()
            default:
                break
            }
        }
    }

    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

// MARK: - Private Configuration Functions

extension MSRectButton {
    private func configureTitle(_ title: String?) {
        configuration?.image = nil
        var container = AttributeContainer()
        container.font = style == .large ? .msFont(.duperTitle) : .msFont(.buttonTitle)
        configuration?.attributedTitle = AttributedString(title ?? "", attributes: container)
    }

    private func configureIcon(_ icon: UIImage?) {
        configuration?.attributedTitle = nil
        configuration?.image = icon
    }

    private func configureSize(by style: Style) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: style.size.width),
            heightAnchor.constraint(equalToConstant: style.size.height),
        ])
    }

    private func configureCornerStyle(by style: Style) {
        layer.cornerRadius = style.cornerRadius
        clipsToBounds = true
    }
}
