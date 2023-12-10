//
//  JourneyCell.swift
//  MSUIKit
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

import MSDesignSystem
import MSImageFetcher

public final class JourneyCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    public static let estimatedHeight: CGFloat = 268.0
    
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
    
    let spotImageStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.spacing
        return stackView
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    public override func prepareForReuse() {
        self.spotImageStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    // MARK: - Functions
    
    public func update(with model: JourneyCellModel) {
        self.infoView.update(location: model.location,
                             date: model.date,
                             title: model.song?.title,
                             artist: model.song?.artist)
    }
    
    public func updateImages(with photoURLs: [URL], for indexPath: IndexPath) {
        self.addImageView(count: photoURLs.count)
        
        photoURLs.enumerated().forEach { index, photoURL in
            let photoIndexPath = IndexPath(item: index, section: indexPath.item)
            self.updateImage(with: photoURL, at: photoIndexPath)
        }
    }
    
    @MainActor
    public func addImageView(count: Int) {
        guard count != .zero else { return }
        
        (1...count).forEach { _ in
            let imageView = SpotPhotoImageView()
            self.spotImageStack.addArrangedSubview(imageView)
        }
    }
    
    public func updateImage(with imageURL: URL, at indexPath: IndexPath) {
        guard self.spotImageStack.arrangedSubviews.count > indexPath.item else {
            return
        }
        guard let photoView = self.spotImageStack.arrangedSubviews[indexPath.item] as? SpotPhotoImageView else {
            return
        }
        
        let key = "\(indexPath.section)-\(indexPath.item)"
        photoView.imageView.ms.setImage(with: imageURL, forKey: key)
    }
    
}

// MARK: - UI Configuration

private extension JourneyCell {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.componentBackground)
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
    func configureLayout() {
        self.addSubview(self.infoView)
        self.infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.infoView.topAnchor.constraint(equalTo: self.topAnchor,
                                               constant: Metric.verticalInset),
            self.infoView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: Metric.horizontalInset),
            self.infoView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -Metric.horizontalInset)
        ])
        
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor,
                                                 constant: Metric.spacing),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: Metric.horizontalInset),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -Metric.horizontalInset),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                    constant: -Metric.verticalInset)
        ])
        
        self.scrollView.addSubview(self.spotImageStack)
        self.spotImageStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.spotImageStack.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.spotImageStack.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.spotImageStack.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.spotImageStack.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.spotImageStack.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor)
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
        cell.heightAnchor.constraint(equalToConstant: 268.0)
    ])
    
    (1...10).forEach { _ in
        let imageView = SpotPhotoImageView()
        imageView.backgroundColor = .systemBlue
        cell.spotImageStack.addArrangedSubview(imageView)
    }
    
    return cell
}
