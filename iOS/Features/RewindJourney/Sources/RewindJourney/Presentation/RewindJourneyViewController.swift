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
            static let inset: CGFloat = 12.0
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
    private var presentingImageIndex: Int? {
        didSet {
            DispatchQueue.main.async { self.changeProgressViews() }
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
    private let presentImageView = UIImageView()
    
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.trigger(.startAutoPlay)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.musicPlayer.stop()
        self.viewModel.trigger(.stopAutoPlay)
    }
    
    // MARK: - Combine Binding
    
    private func bind() {
        self.viewModel.state.photoURLs
            .receive(on: DispatchQueue.main)
            .sink { [weak self] urls in
                self?.configureProgressViewsLayout(urls: urls)
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
    
    private func restartTimer() {
        self.viewModel.trigger(.stopAutoPlay)
        self.viewModel.trigger(.startAutoPlay)
    }
    
    // MARK: - Actions
    
    private func leftTouchViewTapped() {
        guard let presentingImageIndex = self.presentingImageIndex else { return }
        
        if presentingImageIndex > .zero {
            let index = presentingImageIndex - 1
            self.presentingImageIndex = index
        }
    }
    
    private func rightTouchViewDidTap() {
        guard let presentingImageIndex = self.presentingImageIndex else { return }
        
        if presentingImageIndex < self.viewModel.state.photoURLs.value.count - 1 {
            let index = presentingImageIndex + 1
            self.presentingImageIndex = index
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
        self.configureStyle()
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
        self.view.addSubview(self.presentImageView)
        self.presentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.presentImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.presentImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.presentImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.presentImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func configureStackViewLayout() {
        self.view.addSubview(self.progressStackView)
        self.progressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.progressStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.progressStackView.heightAnchor.constraint(equalToConstant: Metric.Progressbar.height),
            self.progressStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                            constant: Metric.StackView.inset),
            self.progressStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                             constant: -Metric.StackView.inset)])
    }
    
    func configureProgressViewsLayout(urls: [URL]) {
        self.progressViews.forEach { $0.removeFromSuperview() }
        self.progressViews.removeAll()
        urls.forEach { _ in
            let progressView = MSProgressView()
            self.progressStackView.addArrangedSubview(progressView)
            self.progressViews.append(progressView)
        }
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
    
    func configureStyle() {
        self.view.backgroundColor = .msColor(.primaryBackground)
        self.configurePresentImageViewStyle()
        self.configureProgressbarsStyle()
    }
    
    func configurePresentImageViewStyle() {
        self.presentImageView.contentMode = .scaleAspectFit
    }
    
    func configureProgressbarsStyle() {
        self.presentingImageIndex = Metric.Progressbar.defaultIndex
    }
    
    // MARK: - Configuration: Action
    
    func configureAction() {
        self.configureLeftTouchViewAction()
        self.configureRightTouchViewAction()
    }
    
    private func configureLeftTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.leftTouchViewTapped()
        }
        self.leftTouchView.addAction(action, for: .touchUpInside)
    }
    
    func configureRightTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.rightTouchViewDidTap()
        }
        self.rightTouchView.addAction(action, for: .touchUpInside)
    }
    
    func changeProgressViews() {
        let photoURLs = self.viewModel.state.photoURLs.value
        guard let presentingIndex = self.presentingImageIndex,
              photoURLs.count > presentingIndex  else {
            return
        }
        
        let photoURL = photoURLs[presentingIndex]
        self.presentImageView.ms.setImage(with: photoURL, forKey: photoURL.paath())
        self.preHighlightenProgressView = self.progressViews[presentingIndex]
        self.preHighlightenProgressView?.isHighlighted = false
        
        let minIndex: Int = .zero
        let maxIndex = photoURLs.count - 1
        
        for index in minIndex...maxIndex {
            self.progressViews[index].isLeftOfCurrentHighlighting = index < presentingIndex ? true : false
            self.progressViews[index].isHighlighted = index <= presentingIndex ? true : false
        }
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
