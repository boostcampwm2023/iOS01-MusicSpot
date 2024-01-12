//
//  RewindJourneyViewController.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import Combine
import UIKit
import MusicKit

import MSDomain
import MSExtension
import MSLogger
import MSUIKit

public final class RewindJourneyViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Metric {
        
        // progress bar
        enum Progressbar {
            static let height: CGFloat = 4.0
            static let inset: CGFloat = 4.0
            static let defaultIndex: Int = 0
        }
        
        // stackView
        enum StackView {
            static let horizontalInset: CGFloat = 12.0
        }
        
        // musicPlayerView
        enum MusicView {
            static let horizontalInset: CGFloat = 12.0
            static let bottomInset: CGFloat = 34.0
        }
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: RewindJourneyNavigationDelegate?
    private let viewModel: RewindJourneyViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    private var presentingPhotoIndex: Int = .zero {
        willSet {
            self.updatePresentingPhoto(atIndex: newValue)
            self.updateProgressViews(atIndex: newValue)
            self.restartTimer()
        }
    }
    
    // MARK: - Properties: Gesture
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    // MARK: - UI Components
    
    private let musicPlayer = ApplicationMusicPlayer.shared
    
    private let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Metric.Progressbar.inset
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var musicPlayerView: MSMusicPlayerView = {
        let playerView = MSMusicPlayerView()
        playerView.delegate = self
        return playerView
    }()
    
    private var progressViews: [MSProgressView] = []
    private var preHighlightenProgressView: MSProgressView?
    private let leftTouchView = UIButton()
    private let rightTouchView = UIButton()
    
    // MARK: - Initializer
    
    public init(viewModel: RewindJourneyViewModel,
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.configure()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.musicPlayer.stop()
        self.viewModel.trigger(.stopAutoPlay)
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.photoURLs
            .combineLatest(self.viewModel.state.selectedSong)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photoURLs, selectedSong in
                guard let duration = selectedSong?.duration else { return }
                self?.configureProgressViews(count: photoURLs.count, duration: duration)
                self?.presentingPhotoIndex = .zero
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.musicMetadata
            .combineLatest(self.viewModel.state.albumCoverImageData)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] music, albumCover in
                self?.musicPlayerView.title = music.title
                self?.musicPlayerView.artist = music.artist
                self?.musicPlayerView.albumArt = albumCover
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.selectedSong
            .compactMap { $0 }
            .first()
            .sink { [weak self] song in
                self?.musicPlayerView.duration = song.duration
                self?.musicPlayer.queue = ApplicationMusicPlayer.Queue(for: [song])
                self?.viewModel.trigger(.startAutoPlay)
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.isSongPlaying
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPlaying in
                guard let self = self else { return }
                
                if isPlaying {
                    Task {
                        try await self.musicPlayer.prepareToPlay()
                        try await self.musicPlayer.play()
                    }
                    self.musicPlayerView.play()
                } else {
                    self.musicPlayer.pause()
                    self.musicPlayerView.pause()
                }
            }
            .store(in: &self.cancellables)
        
        self.viewModel.state.timerDidEnded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.rightTouchViewDidTap()
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Functions
    
    private func restartTimer() {
        self.viewModel.trigger(.stopAutoPlay)
        self.viewModel.trigger(.startAutoPlay)
    }
    
    private func configureProgressViews(count numberOfPhotos: Int, duration: TimeInterval) {
        self.progressViews.forEach { $0.removeFromSuperview() }
        self.progressViews.removeAll()
        (1...numberOfPhotos).forEach { _ in
            let progressView = MSProgressView(duration: duration / Double(numberOfPhotos))
            self.progressStackView.addArrangedSubview(progressView)
            self.progressViews.append(progressView)
        }
    }
    
    private func updatePresentingPhoto(atIndex presentingPhotoIndex: Int) {
        let photoURLs = self.viewModel.state.photoURLs.value
        let photoURL = photoURLs[presentingPhotoIndex]
        self.imageView.ms.setImage(with: photoURL, forKey: photoURL.paath())
    }
    
    private func updateProgressViews(atIndex presentingPhotoIndex: Int) {
        guard self.progressViews.count > presentingPhotoIndex else { return }
        
        let photoURLs = self.viewModel.state.photoURLs.value
        guard photoURLs.count > presentingPhotoIndex else { return }
        
        DispatchQueue.main.async {
            self.preHighlightenProgressView = self.progressViews[presentingPhotoIndex]
            self.preHighlightenProgressView?.isHighlighted = false
            for index in (.zero...photoURLs.count - 1) {
                self.progressViews[index].isLeftOfCurrentHighlighting = (index < presentingPhotoIndex) ? true : false
                self.progressViews[index].isHighlighted = (index <= presentingPhotoIndex) ? true : false
            }
        }
    }
    
    // MARK: - Actions
    
    private func leftTouchViewDidTap() {
        if self.presentingPhotoIndex > .zero {
            let index = self.presentingPhotoIndex - 1
            self.presentingPhotoIndex = index
        }
    }
    
    private func rightTouchViewDidTap() {
        if self.presentingPhotoIndex < self.viewModel.state.photoURLs.value.count - 1 {
            let index = self.presentingPhotoIndex + 1
            self.presentingPhotoIndex = index
        }
    }
}

// MARK: - MusicPlayerView

extension RewindJourneyViewController: MSMusicPlayerViewDelegate {
    
    public func musicPlayerView(_ musicPlayerView: MSMusicPlayerView, didToggleMedia isPlaying: Bool) {
        self.viewModel.trigger(.toggleMusic(isPlaying: isPlaying))
    }
    
}

// MARK: - UI Configuration

private extension RewindJourneyViewController {
    
    func configure() {
        self.configureLayout()
        self.configureStyles()
        self.configureAction()
        
        self.configureLeftToRightSwipeGesture()
    }
    
    // MARK: - UI Configuration: Layout
    
    func configureLayout() {
        self.configurePresentImageViewLayout()
        self.configureStackViewLayout()
        self.configureTouchViewLayout()
        self.configureMusicViewLayout()
    }
    
    func configurePresentImageViewLayout() {
        self.view.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func configureStackViewLayout() {
        self.view.addSubview(self.progressStackView)
        self.progressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.progressStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.progressStackView.heightAnchor.constraint(equalToConstant: Metric.Progressbar.height),
            self.progressStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                            constant: Metric.StackView.horizontalInset),
            self.progressStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                             constant: -Metric.StackView.horizontalInset)])
    }
    
    func configureTouchViewLayout() {
        self.view.addSubview(self.leftTouchView)
        self.view.addSubview(self.rightTouchView)
        
        self.leftTouchView.translatesAutoresizingMaskIntoConstraints = false
        self.rightTouchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftTouchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.rightTouchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.leftTouchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.rightTouchView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.leftTouchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.rightTouchView.leadingAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.leftTouchView.trailingAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rightTouchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func configureMusicViewLayout() {
        self.view.addSubview(self.musicPlayerView)
        self.musicPlayerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.musicPlayerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                                                         constant: -Metric.MusicView.bottomInset),
            self.musicPlayerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                          constant: Metric.MusicView.horizontalInset),
            self.musicPlayerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                           constant: -Metric.MusicView.horizontalInset)
        ])
    }
    
    // MARK: - UI Configuration: Style
    
    func configureStyles() {
        self.view.backgroundColor = .msColor(.primaryBackground)
        self.updatePresentingPhoto(atIndex: .zero)
        self.updateProgressViews(atIndex: .zero)
    }
    
    // MARK: - Configuration: Action
    
    func configureAction() {
        self.configureLeftTouchViewAction()
        self.configureRightTouchViewAction()
    }
    
    func configureLeftTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.leftTouchViewDidTap()
        }
        self.leftTouchView.addAction(action, for: .touchUpInside)
    }
    
    func configureRightTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.rightTouchViewDidTap()
        }
        self.rightTouchView.addAction(action, for: .touchUpInside)
    }
    
}

// MARK: - Preview

#if DEBUG
import MSData
import MSDesignSystem

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let spotRepository = SpotRepositoryImplementation()
    let songRepository = SongRepositoryImplementation()
    let music = Music(id: UUID().uuidString, title: "Super Shy", artist: "NewJeans", albumCover: nil)
    let rewindJourneyViewModel = RewindJourneyViewModel(photoURLs: [],
                                                        music: music,
                                                        spotRepository: spotRepository,
                                                        songRepository: songRepository)
    let rewindJourneyViewController = RewindJourneyViewController(viewModel: rewindJourneyViewModel)
    return rewindJourneyViewController
}
#endif
