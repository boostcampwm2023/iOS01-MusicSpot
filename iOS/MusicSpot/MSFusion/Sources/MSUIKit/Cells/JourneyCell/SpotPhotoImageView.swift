//
//  SpotPhotoImageView.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

import MSDesignSystem

// MARK: - SpotPhotoImageView

final class SpotPhotoImageView: UIView {

    // MARK: Lifecycle

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyle()
        configureLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Internal

    // MARK: - UI Components

    private(set) var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Functions

    func update(with imageData: Data) {
        imageView.image = UIImage(data: imageData)
    }

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let width: CGFloat = 120.0
        static let height: CGFloat = 150.0
        static let cornerRadius: CGFloat = 5.0
    }

}

// MARK: - UI Configuration

extension SpotPhotoImageView {
    private func configureStyle() {
        backgroundColor = .msColor(.secondaryBackground)
        layer.cornerRadius = Metric.cornerRadius
        clipsToBounds = true
        isUserInteractionEnabled = true
    }

    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Metric.width),
            heightAnchor.constraint(equalToConstant: Metric.height),
        ])

        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview {
    SpotPhotoImageView()
}
