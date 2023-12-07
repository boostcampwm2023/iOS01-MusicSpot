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
    
    private let viewModel: RewindJourneyViewModel
    public var images: [UIImage] = []
    private let cache: MSCacheStorage
    private var cancellables: Set<AnyCancellable> = []
    private var presentImageIndex: Int? {
        didSet {
            self.changeProgressViews()
        }
    }
    
    // MARK: - Properties: Timer
    
    private var timerSubscriber: Set<AnyCancellable> = []
    
    // MARK: - UI Components
    
    private let stackView = UIStackView()
    private let presentImageView = UIImageView()
    private let musicView = MSMusicView()
    private var progressViews: [MSProgressView]?
    private var preHighlightenProgressView: MSProgressView?
    private let leftTouchView = UIButton()
    private let rightTouchView = UIButton()
    
    // MARK: - Initializer
    
    public init(viewModel: RewindJourneyViewModel,
                cache: MSCacheStorage = MSCacheStorage(),
                nibName nibNameOrNil: String? = nil,
                bundle nibBundleOrNil: Bundle? = nil) {
        self.cache = cache
        self.viewModel = viewModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.imageBinding()
        self.configure()
        self.timerBinding()
        self.viewModel.trigger(.viewNeedsLoaded)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        self.viewModel.startTimer()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        self.viewModel.stopTimer()
    }
    
    // MARK: - Combine Binding
    
    func imageBinding() {
        self.viewModel.state.stateJourneyPhotoURLs
            .receive(on: DispatchQueue.main)
            .sink { photoURLs in
                for (index, url) in photoURLs.enumerated() {
                    self.images.append(UIImage())
                    self.load(url: url, key: index)
                }
                self.configureProgressbarsLayout()
            }
            .store(in: &self.cancellables)
    }
    
    private func load(url: URL, key: Int) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.images[key] = image
                }
            }
        }
    }
    
    // MARK: - Timer
    
    private func timerBinding() {
        self.viewModel.timerPublisher
            .sink { [weak self] _ in
                self?.rightTouchViewTapped()
            }
            .store(in: &self.timerSubscriber)
    }
    
    private func timerRestart() {
        self.viewModel.stopTimer()
        self.viewModel.startTimer()
    }
    
    // MARK: - Configuration
    
    func configure() {
        self.configureLayout()
        self.configureStyle()
        self.configureAction()
        
        self.musicView.configure()
    }
    
    // MARK: - UI Configuration: Layout
    
    private func configureLayout() {
        self.configurePresentImageViewLayout()
        self.configureStackViewLayout()
        self.configureProgressbarsLayout()
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
        self.view.addSubview(self.stackView)
        
        self.stackView.axis = .horizontal
        self.stackView.spacing = Metric.Progressbar.inset
        self.stackView.distribution = .fillEqually
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: Metric.Progressbar.height),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                    constant: Metric.StackView.inset),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                     constant: -Metric.StackView.inset)])
    }
    
    private func configureProgressbarsLayout() {
        self.progressViews?.forEach { progressView in
            progressView.removeFromSuperview()
        }
        self.progressViews?.removeAll()
        
        var views = [MSProgressView]()
        self.images.forEach { _ in
            let progressView = MSProgressView()
            views.append(progressView)
            self.stackView.addArrangedSubview(progressView)
        }
        
        self.progressViews = views
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
        self.presentImageIndex = Metric.Progressbar.defaultIndex
    }
    
    // MARK: - Configuration: Action
    
    private func configureAction() {
        self.configureLeftTouchViewAction()
        self.configureRightTouchViewAction()
    }
    
    private func configureLeftTouchViewAction() {
        self.leftTouchView.addTarget(self, action: #selector(leftTouchViewTapped), for: .touchUpInside)
    }
    
    private func configureRightTouchViewAction() {
        self.rightTouchView.addTarget(self, action: #selector(rightTouchViewTapped), for: .touchUpInside)
    }
    
    private func changeProgressViews() {
        guard let presentIndex = self.presentImageIndex else { return }
        if self.images.count == 0 { return }
        
        self.presentImageView.image = images[presentIndex]
        self.preHighlightenProgressView = self.progressViews?[presentIndex]
        self.preHighlightenProgressView?.isHighlighted = false
        
        let minIndex = 0
        let maxIndex = images.count - 1
        
        for index in minIndex...maxIndex {
            self.progressViews?[index].isLeftOfCurrentHighlighting = index < presentIndex ? true : false
            self.progressViews?[index].isHighlighted = index <= presentIndex ? true : false
        }
        self.timerRestart()
    }
    
    // MARK: - Actions
    
    @objc private func leftTouchViewTapped() {
        guard let presentImageIndex else {
            return
        }
        if presentImageIndex > 0 {
            let index = presentImageIndex - 1
            self.presentImageIndex = index
        }
    }
    
    @objc private func rightTouchViewTapped() {
        guard let presentImageIndex else {
            return
        }
        if presentImageIndex < images.count - 1 {
            let index = presentImageIndex + 1
            self.presentImageIndex = index
        }
    }
    
}

// MARK: - Preview

@available(iOS 17, *)
#Preview {
    MSFont.registerFonts()
    let spotRepository = SpotRepositoryImplementation()
    let rewindJourneyViewModel = RewindJourneyViewModel(repository: spotRepository)
    let rewindJourneyViewController = RewindJourneyViewController(viewModel: rewindJourneyViewModel)
    return rewindJourneyViewController
}
