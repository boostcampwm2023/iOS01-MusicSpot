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
    
    private enum Metrix {
        
        static var verticalInset: CGFloat = 8.0
        static var horizonalInset: CGFloat = 12.0
        static var cornerRadius: CGFloat = 8.0
        
        //albumart view
        enum AlbumArtView {
            static var height: CGFloat = 52.0
            static var width: CGFloat = 52.0
        }
        //title view
        enum TitleView {
            static var height: CGFloat = 4.0
            static var inset: CGFloat = 4.0
            static var titleHight: CGFloat = 24.0
            static var subTitleHight: CGFloat = 20.0
        }
        
        //playtime view
        enum PlayTimeView {
            static var width: CGFloat = 67.0
            static var verticalInset: CGFloat = 22.0
            static var horizonalInset: CGFloat = 4.0
            static var conponentsHeight: CGFloat = 24.0
        }
        
    }
    
    private enum Default {
        
        //titleView
        enum TitleView {
            static var title: String = "Attention"
            static var subTitle: String = "NewJeans"
            static var defaultIndex: Int = 0
        }
        
        //stackView
        enum PlayTime {
            static var time: String = "00 : 00"
        }
        
    }
    
    // MARK: - Properties
    
    private var albumArtView = UIImageView()
    private var titleView = UIStackView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var playTimeView = UIStackView()
    private var playTimeLabel = UILabel()
    private let playTimeIconView = UIImageView(image: .msIcon(.voice))
    
    // MARK: - UI Components
    
    public func configure() {
        self.configureLayout()
        self.configureStyle()
    }
    
    // MARK: - UI Components: layout
    
    private func configureLayout() {
        self.configureAlbumArtViewLayout()
        self.configurePlayTimeViewLayout()
        self.configureTitleViewLayout()
    }
    
    private func configureAlbumArtViewLayout() {
        self.addSubview(self.albumArtView)
        self.albumArtView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumArtView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrix.verticalInset),
            self.albumArtView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metrix.verticalInset),
            self.albumArtView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Metrix.horizonalInset),
            self.albumArtView.widthAnchor.constraint(equalToConstant: Metrix.AlbumArtView.width)
        ])
    }

    private func configureTitleViewLayout() {
        self.addSubview(self.titleView)
        self.titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrix.verticalInset),
            self.titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metrix.verticalInset),
            self.titleView.leadingAnchor.constraint(equalTo: self.albumArtView.trailingAnchor, constant: Metrix.horizonalInset),
            self.titleView.trailingAnchor.constraint(equalTo: self.playTimeView.leadingAnchor, constant: -Metrix.horizonalInset),
        ])
        
        self.titleView.addArrangedSubview(self.titleLabel)
        self.titleView.addArrangedSubview(self.subTitleLabel)
        
        self.titleView.axis = .vertical
        self.titleView.spacing = Metrix.TitleView.inset
    }
    
    private func configurePlayTimeViewLayout() {
        self.addSubview(self.playTimeView)
        self.playTimeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.playTimeView.topAnchor.constraint(equalTo: self.topAnchor, constant: Metrix.PlayTimeView.verticalInset),
            self.playTimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Metrix.PlayTimeView.verticalInset),
            self.playTimeView.widthAnchor.constraint(equalToConstant: Metrix.PlayTimeView.width),
            self.playTimeView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Metrix.horizonalInset)
        ])
        
        self.playTimeView.addArrangedSubview(self.playTimeIconView)
        self.playTimeView.addArrangedSubview(self.playTimeLabel)
        
        self.playTimeView.axis = .horizontal
        self.playTimeView.spacing = Metrix.PlayTimeView.horizonalInset
        self.titleView.distribution = .fill
    }
    
    // MARK: - UI Components: style
    
    private func configureStyle() {
        MSFont.registerFonts()
        self.clipsToBounds = true
        self.layer.cornerRadius = Metrix.cornerRadius
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



