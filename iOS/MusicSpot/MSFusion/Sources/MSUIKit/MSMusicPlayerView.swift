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

// MARK: - MSMusicPlayerViewDelegate

public protocol MSMusicPlayerViewDelegate: AnyObject {
    func musicPlayerView(
        _ musicPlayerView: MSMusicPlayerView,
        didChangeStatus playbackStatus: MSMusicPlayerView.PlaybackStatus)
}

// MARK: - MSMusicPlayerView

public final class MSMusicPlayerView: UIView {

    // MARK: Lifecycle

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)

        configureStyles()
        configureLayout()
        configureAction()
    }

    required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based 로 개발되었습니다.")
    }

    deinit { self.timer?.cancel() }

    // MARK: Public

    // MARK: - State

    public enum PlaybackStatus {
        case playing
        case paused
        case stopped
    }

    // MARK: - Properties

    public weak var delegate: MSMusicPlayerViewDelegate?

    public var duration: TimeInterval?

    public var title = "알 수 없는 음악" {
        willSet { updateTitle(newValue) }
    }

    public var artist = "" {
        willSet { updateArtist(newValue) }
    }

    public var albumArt: Data? {
        willSet { updateAlbumArt(newValue) }
    }

    public func play(playbackTime: TimeInterval? = nil) {
        if let playbackTime {
            self.playbackTime = playbackTime
        }

        playbackStatus = .playing
        timer = Timer.publish(every: Metric.progressingTimeInterval, on: .current, in: .common)
            .autoconnect()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.playbackTime += Metric.progressingTimeInterval

                if
                    let playbackTime = self?.playbackTime,
                    let duration = self?.duration,
                    playbackTime >= duration,
                    let self
                {
                    stop()
                    delegate?.musicPlayerView(self, didChangeStatus: .stopped)
                }
            }
    }

    public func pause() {
        playbackStatus = .paused
        timer?.cancel()
    }

    public func stop() {
        playbackStatus = .stopped
        timer?.cancel()
    }

    // MARK: Private

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

    private var timer: AnyCancellable?

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
        return UIButton(configuration: configuration)
    }()

    private var playbackStatus: PlaybackStatus = .stopped {
        willSet { updatePlayingStatus(to: newValue) }
    }

    private var playbackTime: TimeInterval = .zero {
        willSet { updatePlaybackTime(to: newValue) }
    }

    // MARK: - Functions

    private func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    private func updateArtist(_ artist: String) {
        artistLabel.text = artist
    }

    private func updateAlbumArt(_ albumCoverData: Data?) {
        guard let albumCoverData else { return }
        albumCoverView.image = UIImage(data: albumCoverData)
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
        setProgress(to: playbackTime)
        let minute = Int(self.playbackTime / 60.0)
        let second = Int(self.playbackTime.truncatingRemainder(dividingBy: 60.0))
        playTimeLabel.text = String(format: "%02d : %02d", minute, second)
    }

    private func setProgress(to time: TimeInterval, animated: Bool = true) {
        guard let duration else { return }

        let desiredWidth = (time * frame.width) / duration

        if animated {
            UIView.animate(
                withDuration: 0.1,
                delay: .zero,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.2,
                options: [.curveEaseInOut])
            {
                self.progressViewWidthConstraint?.constant = desiredWidth
                self.layoutIfNeeded()
            }
        } else {
            progressViewWidthConstraint?.constant = desiredWidth
        }
    }
}

// MARK: - UI Configuration

extension MSMusicPlayerView {
    private func configureLayout() {
        addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: topAnchor),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        progressViewWidthConstraint = progressView.widthAnchor.constraint(equalToConstant: .zero)
        progressViewWidthConstraint?.isActive = true

        configureAlbumArtViewLayout()
        configurePlayTimeViewLayout()
        configureTitleViewLayout()

        addSubview(controlButton)
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controlButton.topAnchor.constraint(equalTo: topAnchor),
            controlButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            controlButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            controlButton.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func configureAlbumArtViewLayout() {
        addSubview(albumCoverView)
        albumCoverView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumCoverView.centerYAnchor.constraint(equalTo: centerYAnchor),
            albumCoverView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Metric.horizonalInset),
            albumCoverView.widthAnchor.constraint(equalToConstant: Metric.AlbumArtView.size),
            albumCoverView.heightAnchor.constraint(equalToConstant: Metric.AlbumArtView.size),
        ])
    }

    private func configureTitleViewLayout() {
        addSubview(titleStackView)
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleStackView.leadingAnchor.constraint(
                equalTo: albumCoverView.trailingAnchor,
                constant: Metric.horizonalInset),
            titleStackView.trailingAnchor.constraint(
                equalTo: playTimeStackView.leadingAnchor,
                constant: -Metric.horizonalInset),
        ])

        [
            titleLabel,
            artistLabel,
        ].forEach {
            self.titleStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    private func configurePlayTimeViewLayout() {
        addSubview(playTimeStackView)
        playTimeStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playTimeStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            playTimeStackView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Metric.horizonalInset),
        ])

        [
            playTimeIconImageView,
            playTimeLabel,
        ].forEach {
            self.playTimeStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            playTimeIconImageView.widthAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize),
            playTimeIconImageView.heightAnchor.constraint(equalToConstant: Metric.PlayTimeView.iconSize),
        ])
    }

    // MARK: - UI Configuration: Style

    private func configureStyles() {
        clipsToBounds = true
        layer.cornerRadius = Metric.cornerRadius
        backgroundColor = .msColor(.componentBackground).withAlphaComponent(0.7)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
        ])
    }

    // MARK: - UI Configuration: Button Action

    private func configureAction() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }

            switch playbackStatus {
            case .paused: playbackStatus = .playing
            case .playing: playbackStatus = .paused
            default: break
            }
            delegate?.musicPlayerView(self, didChangeStatus: playbackStatus)
        }
        controlButton.addAction(action, for: .touchUpInside)
    }
}
