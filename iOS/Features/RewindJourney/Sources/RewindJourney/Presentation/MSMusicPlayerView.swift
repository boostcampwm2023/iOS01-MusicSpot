//
//  MSMusicPlayerView.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSDesignSystem
import MSLogger

final class MSMusicPlayerView: UIProgressView {
    
    // MARK: - Constants
    
    private enum Metric {
        
        static let horizonalInset: CGFloat = 12.0
        static let cornerRadius: CGFloat = 8.0
        static let height: CGFloat = 68.0
        
        // albumart view
        enum AlbumArtView {
            static let size: CGFloat = 52.0
            static let cornerRadius: CGFloat = 5.0
        }
        
        // playtime view
        enum PlayTimeView {
            static let spacing: CGFloat = 4.0
            static let iconSize: CGFloat = 24.0
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
    
    private let albumArtView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Metric.AlbumArtView.cornerRadius
        imageView.clipsToBounds = true
        imageView.backgroundColor = .msColor(.musicSpot)
        return imageView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.paragraph)
        label.textColor = .msColor(.primaryTypo)
        label.text = Default.TitleView.title
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.secondaryTypo)
        label.text = Default.TitleView.subTitle
        return label
    }()
    
    private let playTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.PlayTimeView.spacing
        stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return stackView
    }()
    
    private let playTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.textFieldTypo)
        label.text = Default.PlayTime.time
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let playTimeIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .msIcon(.voice)
        imageView.tintColor = .msColor(.textFieldTypo)
        return imageView
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureStyle()
        self.configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based 로 개발되었습니다.")
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
            self.albumArtView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.albumArtView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                       constant: Metric.horizonalInset),
            self.albumArtView.widthAnchor.constraint(equalToConstant: Metric.AlbumArtView.size),
            self.albumArtView.heightAnchor.constraint(equalToConstant: Metric.AlbumArtView.size)
        ])
    }

    private func configureTitleViewLayout() {
        self.addSubview(self.titleStackView)
        self.titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.albumArtView.trailingAnchor,
                                                         constant: Metric.horizonalInset),
            self.titleStackView.trailingAnchor.constraint(equalTo: self.playTimeStackView.leadingAnchor,
                                                          constant: -Metric.horizonalInset)
        ])
        
        [
            self.titleLabel,
            self.artistLabel
        ].forEach {
            self.titleStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configurePlayTimeViewLayout() {
        self.addSubview(self.playTimeStackView)
        self.playTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.playTimeStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.playTimeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                             constant: -Metric.horizonalInset)
        ])
        
        [
            self.playTimeIconView,
            self.playTimeLabel
        ].forEach {
            self.playTimeStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            self.playTimeIconView.widthAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize),
            self.playTimeIconView.heightAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize)
        ])
    }
    
    // MARK: - UI Configuration: style
    
    private func configureStyle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Metric.cornerRadius
        self.trackTintColor = .msColor(.textFieldBackground).withAlphaComponent(0.7)
        self.progressTintColor = .msColor(.musicSpot)
        self.progress = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
    }
    
}
