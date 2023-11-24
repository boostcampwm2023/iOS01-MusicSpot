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
    
    private enum Metrix {
        
        //status view
        enum StatusView {
            static var height: CGFloat = 54.0
        }
        //progress bar
        enum Progressbar {
            static var height: CGFloat = 4.0
            static var inset: CGFloat = 4.0
            static var defaultIndex: Int = 0
        }
        
        //stackView
        enum StackView {
            static var inset: CGFloat = 12.0
        }
        
        //musicView
        enum MusicView {
            static var height: CGFloat = 69.0
            static var inset: CGFloat = 12.0
            static var bottomInset: CGFloat = 34.0
        }
        
    }
    
    // MARK: - Properties

    var stackView = UIStackView()
    let statusView = UIView()
    var presentImageView = UIImageView()
    let musicView = MSMusicView()
    var progressViews: [MSProgressView]?
    var preHighlightenProgressView: MSProgressView?
    let leftTouchView = UIButton()
    let rightTouchView = UIButton()
    
    public var images: [UIImage]?
    var presentImageIndex: Int? {
        didSet {
            guard let index = self.presentImageIndex, 
                  let images else { return }
            self.presentImageView.image = images[index]
            self.progressViews?[index].isHighlight = true
            self.preHighlightenProgressView?.isHighlight = false
            self.preHighlightenProgressView = self.progressViews?[index]
        }
    }
    
    // MARK: - UI Components
    
    func configure() {
        self.configureLayout()
        self.configureStyle()
        self.configureAction()
        
        self.musicView.configure()
    }
    
    // MARK: - UI Components: Layout
    
    private func configureLayout() {
        self.configurePresentImageViewLayout()
        self.configureStatusViewLayout()
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
    
    private func configureStatusViewLayout() {
        self.view.addSubview(self.statusView)
        
        self.statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.statusView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.statusView.heightAnchor.constraint(equalToConstant: Metrix.StatusView.height),
            self.statusView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.statusView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func configureStackViewLayout() {
        self.view.addSubview(self.stackView)
        
        self.stackView.axis = .horizontal
        self.stackView.spacing = Metrix.Progressbar.inset
        self.stackView.distribution = .fillEqually
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.statusView.bottomAnchor),
            self.stackView.heightAnchor.constraint(equalToConstant: Metrix.Progressbar.height),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Metrix.StackView.inset),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Metrix.StackView.inset)
        ])
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
            self.musicView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -Metrix.MusicView.bottomInset),
            self.musicView.heightAnchor.constraint(equalToConstant: Metrix.MusicView.height),
            self.musicView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Metrix.MusicView.inset),
            self.musicView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Metrix.MusicView.inset)
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
    
    // MARK: - UI Components: Style
    
    private func configureStyle() {
        
        self.configurePresentImageViewStyle()
        self.configureProgressbarsStyle()
    }
    
    private func configurePresentImageViewStyle() {
        self.presentImageView.contentMode = .scaleAspectFit
    }
    
    private func configureProgressbarsStyle() {
        self.presentImageIndex = Metrix.Progressbar.defaultIndex
    }
    
    // MARK: - Configure: Action
    
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
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configure()
    }
    
    // MARK: - Functions: Action
    
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
