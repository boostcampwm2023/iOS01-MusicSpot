//
//  MSTextField.swift
//  MSUIKit
//
//  Created by 전민건 on 11/14/23.
//

import UIKit

import MSDesignSystem

// MARK: - MSTextField

public class MSTextField: UITextField {

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

    public enum ImageStyle {
        case none
        case search
        case pin
        case calender
        case lock

        // MARK: Internal

        var leftImage: UIImage? {
            switch self {
            case .none:
                nil
            case .search:
                ImageBox.magnifyingglass
            case .pin:
                .msIcon(.location)
            case .calender:
                .msIcon(.calendar)
            case .lock:
                .msIcon(.lock)
            }
        }

        var rightImage: UIImage? {
            switch self {
            case .none, .search:
                nil
            default:
                .msIcon(.arrowRight)
            }
        }
    }

    public var imageStyle: ImageStyle = .none {
        didSet {
            configureImageStyle()
            configureLayout()
        }
    }

    public override var text: String? {
        didSet { convertMode() }
    }

    public override var placeholder: String? {
        didSet { configurePlaceholder() }
    }

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let height: CGFloat = 50.0
        static let leftInset: CGFloat = 22.0
        static let rightInset: CGFloat = 12.0
        static let verticalEdgeInsets: CGFloat = 10.0
        static let imageWidth: CGFloat = 20.0
        static let imageHeight: CGFloat = 20.0
        static let imageInset: CGFloat = 12.0
        static let cornerRadius: CGFloat = 8.0
    }

    private enum ImageBox {
        static let magnifyingglass = UIImage(systemName: "magnifyingglass")
        static let close = UIImage(systemName: "multiply.circle.fill")
    }

    // MARK: - Properties

    private var leftImage = UIImageView()
    private var rightImage = UIImageView()

    // MARK: - UI Configuration

    private func configureStyles() {
        font = .msFont(.caption)

        layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .msColor(.textFieldBackground)

        configureImageStyle()
    }

    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
        ])
        configurePlaceholderLayout()

        addSubview(leftImage)
        addSubview(rightImage)

        configureLeftImageLayout()
        configureRightImageLayout()
    }

    private func configurePlaceholderLayout() {
        configureLeftPlaceholderLayout()
        configureRightPlaceholderLayout()
    }

    private func configureLeftPlaceholderLayout() {
        let extraInset: CGFloat = imageStyle == .none ? 0.0 : Metric.imageWidth + Metric.imageInset
        leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Metric.leftInset + extraInset, height: 0.0))
        leftViewMode = .always
    }

    private func configureRightPlaceholderLayout() {
        let extraInset: CGFloat = hasText ? Metric.imageWidth + Metric.imageInset : 0.0
        rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Metric.rightInset + extraInset, height: 0.0))
        rightViewMode = .always
    }

    private func configureLeftImageLayout() {
        leftImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.leftInset),
            leftImage.heightAnchor.constraint(equalToConstant: Metric.imageHeight),
            leftImage.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            leftImage.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func configureRightImageLayout() {
        rightImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metric.imageInset),
            rightImage.heightAnchor.constraint(equalToConstant: Metric.imageHeight),
            rightImage.widthAnchor.constraint(equalToConstant: Metric.imageWidth),
            rightImage.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func configurePlaceholder() {
        var container = AttributeContainer()
        container.font = .msFont(.caption)
        let attributedString = AttributedString(placeholder ?? "", attributes: container)
        attributedPlaceholder = NSAttributedString(attributedString)
    }
}

// MARK: - Edit/Non-Edit Mode Functions

extension MSTextField {
    public func convertMode() {
        configureRightImageStyle()
        configureRightImageLayout()
    }
}

// MARK: - Private Configuration Functions

extension MSTextField {
    private func configureImageStyle() {
        configureLeftImageStyle()
        configureRightImageStyle()
    }

    private func configureLeftImageStyle() {
        if let leftImage = imageStyle.leftImage {
            self.leftImage.image = leftImage
        }
        leftImage.tintColor = .msColor(.textFieldTypo)
    }

    private func configureRightImageStyle() {
        if let rightImage = imageStyle.rightImage {
            self.rightImage.image = rightImage
        }

        if hasText {
            rightImage.image = ImageBox.close
        }
        rightImage.tintColor = .msColor(.textFieldTypo)
    }

    private func configureImages(color: UIColor) {
        leftImage.tintColor = color
        rightImage.tintColor = color
    }
}
