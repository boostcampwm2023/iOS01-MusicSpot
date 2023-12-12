//
//  MSMusicPlayerView.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import Combine
import UIKit

import MSDesignSystem
import MSDomain
import MSExtension
import MSImageFetcher
import MSLogger

protocol MSMusicPlayerViewDelegate: AnyObject {
    
    func musicPlayerView(_ musicPlayerView: MSMusicPlayerView, didToggleMedia isPlaying: Bool)
    
}

final class MSMusicPlayerView: UIView {
    
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
        }
        
        // stackView
        enum PlayTime {
            static let time: String = "00 : 00"
        }
        
    }
    
    // MARK: - Properties
    
    weak var delegate: MSMusicPlayerViewDelegate?
    
    let playbackPublisher = PassthroughSubject<TimeInterval, Never>()
    var timer: AnyCancellable?
    
    private var isPlaying: Bool = false
    var playbackTime: TimeInterval = .zero
    var duration: TimeInterval?
    
    // MARK: - UI Components
    
    private let progressView = UIView()
    private var progressViewWidthConstraint: NSLayoutConstraint?
    
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
        label.textColor = .msColor(.componentTypo)
        label.text = Default.TitleView.title
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.componentTypo)
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
        label.textColor = .msColor(.componentTypo)
        label.text = Default.PlayTime.time
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private let playTimeIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .msColor(.componentTypo)

        if #available(iOS 17.0, *) {
            imageView.image = UIImage(systemName: "waveform")
        } else {
            imageView.image = .msIcon(.voice)
        }
        
        return imageView
    }()
    
    private let controlButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor = .clear
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        self.isPlaying = true
        super.init(frame: frame)
        
        self.configureStyle()
        self.configureLayout()
        self.configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based 로 개발되었습니다.")
    }
    
    deinit {
        self.pause(playbackTime: .zero)
    }
    
    // MARK: - Functions
    
    public func update(with music: Music) {
        self.titleLabel.text = music.title
        self.artistLabel.text = music.artist
        if let albumCover = music.albumCover,
           let coverURL = albumCover.url {
            self.albumArtView.ms.setImage(with: coverURL, forKey: coverURL.paath())
        }
    }
    
    public func togglePlayingStatus(to isPlaying: Bool) {
        DispatchQueue.main.async {
            self.progressView.backgroundColor = isPlaying ? .msColor(.musicSpot) : .msColor(.componentBackground)
            
            if #available(iOS 17.0, *) {
                if isPlaying {
                    self.playTimeIconView.addSymbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                } else {
                    self.playTimeIconView.removeAllSymbolEffects()
                }
            }
        }
    }
    
    public func play(progressingTimeInterval: TimeInterval = 0.1) {
        self.timer = Timer.publish(every: progressingTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.playbackTime += progressingTimeInterval
                DispatchQueue.main.async {
                    self.setProgress(to: self.playbackTime)
                    let minute = Int(self.playbackTime / 60.0)
                    let second = Int(self.playbackTime.truncatingRemainder(dividingBy: 60.0))
                    self.playTimeLabel.text = String(format: "%02d : %02d", minute, second)
                }
            }
        self.isPlaying = true
    }
    
    public func pause(playbackTime: TimeInterval) {
        self.timer?.cancel()
        self.playbackTime = playbackTime
        self.isPlaying = false
    }
    
    private func setProgress(to time: TimeInterval, animted: Bool = true) {
        guard let duration = self.duration else { return }
        
        let desiredWidth = (time * self.frame.width) / duration
        
        UIView.animate(withDuration: 0.1,
                       delay: .zero,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseInOut]) {
            self.progressViewWidthConstraint?.constant = desiredWidth
            self.layoutIfNeeded()
        }
    }
    
}

// MARK: - UI Configuration

private extension MSMusicPlayerView {
    
    func configureLayout() {
        self.addSubview(self.progressView)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.progressView.topAnchor.constraint(equalTo: self.topAnchor),
            self.progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.progressView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.progressViewWidthConstraint = self.progressView.widthAnchor.constraint(equalToConstant: .zero)
        self.progressViewWidthConstraint?.isActive = true
        
        self.configureAlbumArtViewLayout()
        self.configurePlayTimeViewLayout()
        self.configureTitleViewLayout()
        
        self.addSubview(self.controlButton)
        self.controlButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.controlButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.controlButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.controlButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.controlButton.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureAlbumArtViewLayout() {
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
    
    func configureTitleViewLayout() {
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
    
    func configurePlayTimeViewLayout() {
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
    
    // MARK: - UI Configuration: Style
    
    func configureStyle() {
        self.clipsToBounds = true
        self.layer.cornerRadius = Metric.cornerRadius
        self.backgroundColor = .msColor(.componentBackground).withAlphaComponent(0.7)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: Metric.height)
        ])
    }
    
    // MARK: - UI Configuration: Button Action
    
    func configureAction() {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.isPlaying.toggle()
            self.delegate?.musicPlayerView(self, didToggleMedia: self.isPlaying)
        }
        self.controlButton.addAction(action, for: .touchUpInside)
    }
    
}
