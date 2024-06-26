//
//  MSMusicPlayerView.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.12.
//

import Combine
import UIKit

import MSDesignSystem
import MSExtension
import MSLogger

public protocol MSMusicPlayerViewDelegate: AnyObject {
    func musicPlayerView(_ musicPlayerView: MSMusicPlayerView,
                         didChangeStatus playbackStatus: MSMusicPlayerView.PlaybackStatus)
}

public final class MSMusicPlayerView: UIView {
    // MARK: - Constants

    private enum Metric {
        static let horizonalInset: CGFloat = 12.0
        static let cornerRadius: CGFloat = 8.0
        static let height: CGFloat = 68.0
        static let progressingTimeInterval: TimeInterval = 0.1

        enum AlbumArtView {
            static let size: CGFloat = 52.0
            static let cornerRadius: CGFloat = 5.0
        }

        enum PlayTimeView {
            static let spacing: CGFloat = 4.0
            static let iconSize: CGFloat = 24.0
        }
    }

    // MARK: - State

    public enum PlaybackStatus {
        case playing
        case paused
        case stopped
    }

    // MARK: - Properties

    public weak var delegate: MSMusicPlayerViewDelegate?

    public var title: String = "알 수 없는 음악" {
        willSet { self.updateTitle(newValue) }
    }

    public var artist: String = "" {
        willSet { self.updateArtist(newValue) }
    }

    public var albumArt: Data? {
        willSet { self.updateAlbumArt(newValue) }
    }

    private var playbackStatus: PlaybackStatus = .stopped {
        willSet { self.updatePlayingStatus(to: newValue) }
    }

    public var duration: TimeInterval?

    private var timer: AnyCancellable?

    private var playbackTime: TimeInterval = .zero {
        willSet { self.updatePlaybackTime(to: newValue) }
    }

    // MARK: - UI Components

    private let progressView = UIView()
    private var progressViewWidthConstraint: NSLayoutConstraint?

    private let albumCoverView: UIImageView = {
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
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = .msFont(.caption)
        label.textColor = .msColor(.componentTypo)
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
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let playTimeIconImageView: UIImageView = {
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
        super.init(frame: frame)

        self.configureStyles()
        self.configureLayout()
        self.configureAction()
    }

    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based 로 개발되었습니다.")
    }

    deinit { self.timer?.cancel() }

    // MARK: - Functions

    private func updateTitle(_ title: String) {
        self.titleLabel.text = title
    }

    private func updateArtist(_ artist: String) {
        self.artistLabel.text = artist
    }

    private func updateAlbumArt(_ albumCoverData: Data?) {
        guard let albumCoverData = albumCoverData else { return }
        self.albumCoverView.image = UIImage(data: albumCoverData)
    }

    private func updatePlayingStatus(to playbackStatus: PlaybackStatus) {
        DispatchQueue.main.async {
            switch playbackStatus {
            case .playing:
                self.progressView.backgroundColor = .msColor(.musicSpot)
            case .paused, .stopped:
                self.progressView.backgroundColor = .msColor(.componentBackground)
            }

            if #available(iOS 17.0, *) {
                if case .playing = playbackStatus {
                    self.playTimeIconImageView
                        .addSymbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
                } else {
                    self.playTimeIconImageView.removeAllSymbolEffects()
                }
            }
        }
    }

    private func updatePlaybackTime(to playbackTime: TimeInterval) {
        self.setProgress(to: playbackTime)
        let minute = Int(self.playbackTime / 60.0)
        let second = Int(self.playbackTime.truncatingRemainder(dividingBy: 60.0))
        self.playTimeLabel.text = String(format: "%02d : %02d", minute, second)
    }

    public func play(playbackTime: TimeInterval? = nil) {
        if let playbackTime = playbackTime {
            self.playbackTime = playbackTime
        }

        self.playbackStatus = .playing
        self.timer = Timer.publish(every: Metric.progressingTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.playbackTime += Metric.progressingTimeInterval

                if let playbackTime = self?.playbackTime,
                   let duration = self?.duration,
                   playbackTime >= duration,
                   let self = self {
                    self.stop()
                    self.delegate?.musicPlayerView(self, didChangeStatus: .stopped)
                }
            }
    }

    public func pause() {
        self.playbackStatus = .paused
        self.timer?.cancel()
    }

    public func stop() {
        self.playbackStatus = .stopped
        self.timer?.cancel()
    }

    private func setProgress(to time: TimeInterval, animated: Bool = true) {
        guard let duration = self.duration else { return }

        let desiredWidth = (time * self.frame.width) / duration

        if animated {
            UIView.animate(withDuration: 0.1,
                           delay: .zero,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.2,
                           options: [.curveEaseInOut]) {
                self.progressViewWidthConstraint?.constant = desiredWidth
                self.layoutIfNeeded()
            }
        } else {
            self.progressViewWidthConstraint?.constant = desiredWidth
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
        self.addSubview(self.albumCoverView)
        self.albumCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.albumCoverView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.albumCoverView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                       constant: Metric.horizonalInset),
            self.albumCoverView.widthAnchor.constraint(equalToConstant: Metric.AlbumArtView.size),
            self.albumCoverView.heightAnchor.constraint(equalToConstant: Metric.AlbumArtView.size)
        ])
    }

    func configureTitleViewLayout() {
        self.addSubview(self.titleStackView)
        self.titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleStackView.leadingAnchor.constraint(equalTo: self.albumCoverView.trailingAnchor,
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
            self.playTimeIconImageView,
            self.playTimeLabel
        ].forEach {
            self.playTimeStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            self.playTimeIconImageView.widthAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize),
            self.playTimeIconImageView.heightAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize)
        ])
    }

    // MARK: - UI Configuration: Style

    func configureStyles() {
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

            switch self.playbackStatus {
            case .paused: self.playbackStatus = .playing
            case .playing: self.playbackStatus = .paused
            default: break
            }
            self.delegate?.musicPlayerView(self, didChangeStatus: self.playbackStatus)
        }
        self.controlButton.addAction(action, for: .touchUpInside)
    }
}
