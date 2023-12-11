//
//  RewindJourneyViewController.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import UIKit
import Combine

import MSCacheStorage
import MSData
import MSDesignSystem
import MSExtension
import MSImageFetcher
import MSLogger

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
        
        // musicView
        enum MusicView {
            static let height: CGFloat = 69.0
            static let inset: CGFloat = 12.0
            static let bottomInset: CGFloat = 34.0
        }
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: RewindJourneyNavigationDelegate?
    private let viewModel: RewindJourneyViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    private var presentingImageIndex: Int? {
        didSet {
            self.changeProgressViews()
            self.restartTimer()
        }
    }
    
    // MARK: - Properties: Timer
    
    private var timerSubscriber: Set<AnyCancellable> = []
    
    // MARK: - Properties: Gesture
    
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    // MARK: - UI Components
    
    private let progressStackView = UIStackView()
    private let presentImageView = UIImageView()
    private let musicView = MSMusicView()
    private var progressViews: [MSProgressView]?
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
        self.progressViewBinding()
        self.timerBinding()
        self.configure()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.viewModel.trigger(.startAutoPlay)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.trigger(.stopAutoPlay)
    }
    
    // MARK: - Combine Binding
    
    private func progressViewBinding() {
        self.viewModel.state.photoURLs
            .sink { [weak self] urls in
                self?.configureProgressViewsLayout(urls: urls)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: - Timer
    
    private func timerBinding() {
        self.viewModel.state.timerPublisher
            .sink { [weak self] _ in
                DispatchQueue.main.async { self?.rightTouchViewDidTap() }
            }
            .store(in: &self.timerSubscriber)
    }
    
    private func restartTimer() {
        self.viewModel.trigger(.stopAutoPlay)
        self.viewModel.trigger(.startAutoPlay)
    }
    
    // MARK: - Configuration
    
    func configure() {
        self.configureLayout()
        self.configureStyle()
        self.configureAction()
        
        self.musicView.configure()
        self.configureLeftToRightSwipeGesture()
    }
    
    // MARK: - UI Configuration: Layout
    
    private func configureLayout() {
        self.configurePresentImageViewLayout()
        self.configureStackViewLayout()
        self.configureMusicViewLayout()
        self.configureTouchViewLayout()
    }
    
    private func configurePresentImageViewLayout() {
        self.view.addSubview(self.presentImageView)
        
        self.presentImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.presentImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.presentImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.presentImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.presentImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configureStackViewLayout() {
        self.view.addSubview(self.progressStackView)
        
        self.progressStackView.axis = .horizontal
        self.progressStackView.spacing = Metric.Progressbar.inset
        self.progressStackView.distribution = .fillEqually
        
        self.progressStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.progressStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.progressStackView.heightAnchor.constraint(equalToConstant: Metric.Progressbar.height),
            self.progressStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                            constant: Metric.StackView.inset),
            self.progressStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                             constant: -Metric.StackView.inset)])
    }
    
    @MainActor
    private func configureProgressViewsLayout(urls: [URL]) {
        self.progressViews?.forEach { $0.removeFromSuperview() }
        self.progressViews?.removeAll()
        
        urls.forEach { _ in
            let progressView = MSProgressView()
            self.progressStackView.addArrangedSubview(progressView)
            if self.progressViews == nil { self.progressViews = [] }
            self.progressViews?.append(progressView)
        }
    }
    
    private func configureMusicViewLayout() {
        self.view.addSubview(self.musicView)
        
        self.musicView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.musicView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                   constant: -Metric.MusicView.bottomInset),
            self.musicView.heightAnchor.constraint(equalToConstant: Metric.MusicView.height),
            self.musicView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: Metric.MusicView.inset),
            self.musicView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -Metric.MusicView.inset)
        ])
    }
    
    private func configureTouchViewLayout() {
        self.view.addSubview(self.leftTouchView)
        self.view.addSubview(self.rightTouchView)
        
        self.leftTouchView.translatesAutoresizingMaskIntoConstraints = false
        self.rightTouchView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leftTouchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.rightTouchView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.leftTouchView.bottomAnchor.constraint(equalTo: self.musicView.topAnchor),
            self.rightTouchView.bottomAnchor.constraint(equalTo: self.musicView.topAnchor),
            self.leftTouchView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.rightTouchView.leadingAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.leftTouchView.trailingAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.rightTouchView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    // MARK: - UI Configuration: Style
    
    private func configureStyle() {
        self.view.backgroundColor = .msColor(.primaryBackground)
        self.configurePresentImageViewStyle()
        self.configureProgressbarsStyle()
    }
    
    private func configurePresentImageViewStyle() {
        self.presentImageView.contentMode = .scaleAspectFit
    }
    
    private func configureProgressbarsStyle() {
        self.presentingImageIndex = Metric.Progressbar.defaultIndex
    }
    
    // MARK: - Configuration: Action
    
    private func configureAction() {
        self.configureLeftTouchViewAction()
        self.configureRightTouchViewAction()
    }
    
    private func configureLeftTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.leftTouchViewTapped()
        }
        self.leftTouchView.addAction(action, for: .touchUpInside)
    }
    
    private func configureRightTouchViewAction() {
        let action = UIAction { [weak self] _ in
            self?.rightTouchViewDidTap()
        }
        self.rightTouchView.addAction(action, for: .touchUpInside)
    }
    
    private func changeProgressViews() {
        let photoURLs = self.viewModel.state.photoURLs.value
        guard let presentingIndex = self.presentingImageIndex,
              photoURLs.count > presentingIndex  else {
            return
        }
        
        let photoURL = photoURLs[presentingIndex]
        self.presentImageView.ms.setImage(with: photoURL, forKey: photoURL.paath())
        self.preHighlightenProgressView = self.progressViews?[presentingIndex]
        self.preHighlightenProgressView?.isHighlighted = false
        
        let minIndex: Int = .zero
        let maxIndex = photoURLs.count - 1
        
        for index in minIndex...maxIndex {
            self.progressViews?[index].isLeftOfCurrentHighlighting = index < presentingIndex ? true : false
            self.progressViews?[index].isHighlighted = index <= presentingIndex ? true : false
        }
    }
    
    // MARK: - Actions
    
    private func leftTouchViewTapped() {
        guard let presentingImageIndex = self.presentingImageIndex else { return }
        
        if presentingImageIndex > 0 {
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

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let spotRepository = SpotRepositoryImplementation()
    let rewindJourneyViewModel = RewindJourneyViewModel(photoURLs: [], repository: spotRepository)
    let rewindJourneyViewController = RewindJourneyViewController(viewModel: rewindJourneyViewModel)
    return rewindJourneyViewController
}
