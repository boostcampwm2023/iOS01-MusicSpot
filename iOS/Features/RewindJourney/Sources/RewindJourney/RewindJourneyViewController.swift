//
//  RewindJourneyViewController.swift
//  RewindJourney
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSDesignSystem

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
    
    private let stackView = UIStackView()
    private let presentImageView = UIImageView()
    private let musicView = MSMusicView()
    private var progressViews: [MSProgressView]?
    private var preHighlightenProgressView: MSProgressView?
    private let leftTouchView = UIButton()
    private let rightTouchView = UIButton()
    
    public var images: [UIImage]?
    private var presentImageIndex: Int? {
        didSet {
            self.changeProgressViews()
        }
    }
    
    // MARK: - UI Configuration
    
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
        guard let images else { return }
        var views = [MSProgressView]()
        images.forEach {_ in
            let progressView = MSProgressView()
            views.append(progressView)
            stackView.addArrangedSubview(progressView)
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
        guard let presentIndex = self.presentImageIndex,
              let images else { return }
        
        self.presentImageView.image = images[presentIndex]
        self.preHighlightenProgressView = self.progressViews?[presentIndex]
        self.preHighlightenProgressView?.isHighlighted = false
        
        let minIndex = 0
        let maxIndex = images.count - 1
        
        for index in minIndex...maxIndex {
            self.progressViews?[index].isHighlighted = index <= presentIndex ? true : false
        }
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
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
        guard let images, let presentImageIndex else {
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
    let viewController = RewindJourneyViewController()
    viewController.images = [UIImage(systemName: "pencil")!,
                             UIImage(systemName: "pencil")!,
                             UIImage(systemName: "pencil")!]
    return viewController
}
