//
//  MSMusicView.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSDesignSystem
import MSLogger
import MSUIKit

final class MSMusicView: UIProgressView {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let verticalInset: CGFloat = 8.0
        static let horizonalInset: CGFloat = 12.0
        static let cornerRadius: CGFloat = 8.0
        
        // albumart view
        enum AlbumArtView {
            static let height: CGFloat = 52.0
            static let width: CGFloat = 52.0
        }
        // title view
        enum TitleView {
            static let height: CGFloat = 4.0
            static let inset: CGFloat = 4.0
            static let titleHight: CGFloat = 24.0
            static let subTitleHight: CGFloat = 20.0
        }
        
        // playtime view
        enum PlayTimeView {
            static let width: CGFloat = 67.0
            static let verticalInset: CGFloat = 22.0
            static let horizonalInset: CGFloat = 4.0
            static let conponentsHeight: CGFloat = 24.0
        }
        
    }
    
    private enum Default {
        
        // titleView
        enum TitleView {
            static let title: String = "Attention"
            static let subTitle: String = "NewJeans"
            static let defaultIndex: Int = 0
        }
        
        // stackView
        enum PlayTime {
            static let time: String = "00 : 00"
        }
        
    }
    
    // MARK: - UI Components
    
    private let albumArtView = UIImageView()
    public var albumArtImage: UIImage? {
        didSet {
            self.albumArtView.image = albumArtImage
        }
    }
    private let titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let playTimeStackView = UIStackView()
    private let playTimeLabel = UILabel()
    private let playTimeIconView = UIImageView(image: .msIcon(.voice))
    
    // MARK: - UI Configuration
    
    public func configure() {
        self.configureLayout()
        self.configureStyle()
    }
    
    // MARK: - UI Configuration: layout
    
    private func configureLayout() {
        self.configureAlbumArtViewLayout()
        self.configurePlayTimeViewLayout()
        self.configureTitleViewLayout()
    }
    
    private func configureAlbumArtViewLayout() {
        self.addSubview(self.albumArtView)
        self.albumArtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumArtView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metric.verticalInset),
            self.albumArtView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metric.verticalInset),
            self.albumArtView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metric.horizonalInset),
            self.albumArtView.widthAnchor.constraint(equalToConstant: Metric.AlbumArtView.width)
        ])
    }

    private func configureTitleViewLayout() {
        self.addSubview(self.titleStackView)
        self.titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                constant: Metric.verticalInset),
            self.titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                   constant: -Metric.verticalInset),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.albumArtView.trailingAnchor,
                                                    constant: Metric.horizonalInset),
            self.titleStackView.trailingAnchor.constraint(equalTo: self.playTimeStackView.leadingAnchor,
                                                     constant: -Metric.horizonalInset)
        ])
        
        self.titleStackView.addArrangedSubview(self.titleLabel)
        self.titleStackView.addArrangedSubview(self.subTitleLabel)
        
        self.titleStackView.axis = .vertical
        self.titleStackView.spacing = Metric.TitleView.inset
    }
    
    private func configurePlayTimeViewLayout() {
        self.addSubview(self.playTimeStackView)
        self.playTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.playTimeStackView.topAnchor.constraint(equalTo: self.topAnchor,
                                                   constant: Metric.PlayTimeView.verticalInset),
            self.playTimeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                      constant: -Metric.PlayTimeView.verticalInset),
            self.playTimeStackView.widthAnchor.constraint(equalToConstant: Metric.PlayTimeView.width),
            self.playTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                        constant: -Metric.horizonalInset)
        ])
        
        self.playTimeStackView.addArrangedSubview(self.playTimeIconView)
        self.playTimeStackView.addArrangedSubview(self.playTimeLabel)
        
        self.playTimeStackView.axis = .horizontal
        self.playTimeStackView.spacing = Metric.PlayTimeView.horizonalInset
        self.titleStackView.distribution = .fill
    }
    
    // MARK: - UI Configuration: style
    
    private func configureStyle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Metric.cornerRadius
        self.trackTintColor = .msColor(.secondaryBackground)
        self.progressTintColor = .msColor(.musicSpot)
        self.progress = 0.4
        
        self.configureTitleViewStyle()
        self.configurePlayTimeViewStyle()
    }
    
    private func configureTitleViewStyle() {
        self.titleLabel.text = Default.TitleView.title
        self.titleLabel.font = .msFont(.buttonTitle)
        self.subTitleLabel.text = Default.TitleView.subTitle
        self.subTitleLabel.font = .msFont(.paragraph)
    }
    
    private func configurePlayTimeViewStyle() {
        self.playTimeLabel.text = Default.PlayTime.time
        self.playTimeLabel.font = .msFont(.caption)
        self.playTimeLabel.textColor = .msColor(.secondaryTypo)
        self.playTimeIconView.tintColor = .msColor(.secondaryTypo)
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let musicView = MSMusicView()
    musicView.albumArtImage = UIImage(systemName: "pencil")
    return musicView
}
