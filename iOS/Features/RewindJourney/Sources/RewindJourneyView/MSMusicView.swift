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
        
        static var verticalInset: CGFloat = 8.0
        static var horizonalInset: CGFloat = 12.0
        static var cornerRadius: CGFloat = 8.0
        
        // albumart view
        enum AlbumArtView {
            static var height: CGFloat = 52.0
            static var width: CGFloat = 52.0
        }
        // title view
        enum TitleView {
            static var height: CGFloat = 4.0
            static var inset: CGFloat = 4.0
            static var titleHight: CGFloat = 24.0
            static var subTitleHight: CGFloat = 20.0
        }
        
        // playtime view
        enum PlayTimeView {
            static var width: CGFloat = 67.0
            static var verticalInset: CGFloat = 22.0
            static var horizonalInset: CGFloat = 4.0
            static var conponentsHeight: CGFloat = 24.0
        }
        
    }
    
    private enum Default {
        
        // titleView
        enum TitleView {
            static var title: String = "Attention"
            static var subTitle: String = "NewJeans"
            static var defaultIndex: Int = 0
        }
        
        // stackView
        enum PlayTime {
            static var time: String = "00 : 00"
        }
        
    }
    
    // MARK: - UI Components
    
    private var albumArtView = UIImageView()
    private var titleStackView = UIStackView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var playTimeStackView = UIStackView()
    private var playTimeLabel = UILabel()
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
        
        self.configureAlbumArtViewStyle()
        self.configureTitleViewStyle()
        self.configurePlayTimeViewStyle()
    }
    
    private func configureAlbumArtViewStyle() {
        self.albumArtView.backgroundColor = .blue
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
