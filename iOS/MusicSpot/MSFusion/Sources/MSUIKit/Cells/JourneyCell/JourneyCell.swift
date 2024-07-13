//
//  JourneyCell.swift
//  MSUIKit
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

import MSDesignSystem
import MSExtension
import MSImageFetcher

// MARK: - JourneyCell

public final class JourneyCell: UICollectionViewCell {

    // MARK: Lifecycle

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
        configureLayout()
    }

    public required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Public

    // MARK: - Constants

    public static let estimatedHeight: CGFloat = 268.0

    public override func prepareForReuse() {
        for arrangedSubview in spotImageStack.arrangedSubviews {
            arrangedSubview.removeFromSuperview()
        }
    }

    // MARK: - Functions

    public func update(with model: JourneyCellModel) {
        // TODO: 바뀐 Journey 적용
        infoView.update(
            location: model.location,
            date: model.date,
            title: nil,
            artist: nil)
    }

    public func updateImages(with photoURLs: [URL], for indexPath: IndexPath) {
        addImageView(count: photoURLs.count)

        for (index, photoURL) in photoURLs.enumerated() {
            let photoIndexPath = IndexPath(item: index, section: indexPath.item)
            updateImage(with: photoURL, at: photoIndexPath)
        }
    }

    @MainActor
    public func addImageView(count: Int) {
        guard count != .zero else { return }

        for _ in 1...count {
            let imageView = SpotPhotoImageView()
            spotImageStack.addArrangedSubview(imageView)
        }
    }

    public func updateImage(with imageURL: URL, at indexPath: IndexPath) {
        guard spotImageStack.arrangedSubviews.count > indexPath.item else {
            return
        }
        guard let photoView = spotImageStack.arrangedSubviews[indexPath.item] as? SpotPhotoImageView else {
            return
        }

        photoView.imageView.ms.setImage(with: imageURL, forKey: imageURL.paath())
    }

    // MARK: Internal

    let spotImageStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.spacing
        return stackView
    }()

    // MARK: Private

    private enum Metric {
        static let cornerRadius: CGFloat = 12.0
        static let spacing: CGFloat = 5.0
        static let verticalInset: CGFloat = 20.0
        static let horizontalInset: CGFloat = 16.0
    }

    // MARK: - UI Components

    private let infoView = JourneyInfoView()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    }()

}

// MARK: - UI Configuration

extension JourneyCell {
    private func configureStyles() {
        backgroundColor = .msColor(.componentBackground)
        layer.cornerRadius = Metric.cornerRadius
        clipsToBounds = true
    }

    private func configureLayout() {
        addSubview(infoView)
        infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: Metric.verticalInset),
            infoView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metric.horizontalInset),
            infoView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Metric.horizontalInset),
        ])

        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: infoView.bottomAnchor,
                constant: Metric.spacing),
            scrollView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metric.horizontalInset),
            scrollView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Metric.horizontalInset),
            scrollView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -Metric.verticalInset),
        ])

        scrollView.addSubview(spotImageStack)
        spotImageStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spotImageStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            spotImageStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            spotImageStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            spotImageStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            spotImageStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }
}

// MARK: - Preview

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 373.0, height: 268.0)) {
    MSFont.registerFonts()

    let cell = JourneyCell()
    NSLayoutConstraint.activate([
        cell.widthAnchor.constraint(equalToConstant: 373.0),
        cell.heightAnchor.constraint(equalToConstant: 268.0),
    ])

    for _ in 1...10 {
        let imageView = SpotPhotoImageView()
        imageView.backgroundColor = .systemBlue
        cell.spotImageStack.addArrangedSubview(imageView)
    }

    return cell
}
