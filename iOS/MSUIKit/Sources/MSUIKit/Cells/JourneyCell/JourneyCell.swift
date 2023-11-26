//
//  JourneyCell.swift
//  MSUIKit
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

import MSDesignSystem

public final class JourneyCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    public static let estimatedHeight: CGFloat = 268.0
    
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
        stackView.spacing = 5.0
        return stackView
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
        self.configureLayout()
        
        (1...10).forEach { _ in
            let imageView = SpotPhotoImageView()
            imageView.backgroundColor = .systemBlue
            self.spotImageStack.addArrangedSubview(imageView)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    public func update(with data: String) {
        
    }
    
}

// MARK: - UI Configuration

private extension JourneyCell {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.componentBackground)
        self.layer.cornerRadius = 12.0
        self.clipsToBounds = true
    }
    
    func configureLayout() {
        self.addSubview(self.infoView)
        self.infoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.infoView.topAnchor.constraint(equalTo: self.topAnchor,
                                               constant: 20.0),
            self.infoView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                   constant: 16.0),
            self.infoView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                    constant: -16.0)
        ])
        
        self.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.infoView.bottomAnchor,
                                                 constant: 5.0),
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                     constant: 16.0),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                      constant: -16.0),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                    constant: -20.0)
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