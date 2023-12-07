//
//  SpotViewController.swift
//  Spot
//
//  Created by 전민건 on 11/22/23.
//

import UIKit

import MSData
import MSDesignSystem
import MSLogger
import MSUIKit

public final class SpotSaveViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Metric {
        
        // image view
        enum ImageView {
            static let height: CGFloat = 486.0
            static let inset: CGFloat = 4.0
            static let defaultIndex: Int = 0
        }
        
        // labels
        enum TextLabel {
            static let height: CGFloat = 24.0
            static let topInset: CGFloat = 30.0
        }
        
        enum SubTextLabel {
            static let height: CGFloat = 42.0
            static let topInset: CGFloat = 2.0
        }
        
        // buttons
        enum Button {
            static let height: CGFloat = 120.0
            static let width: CGFloat = 120.0
            static let insetFromCenterX: CGFloat = 26.0
            static let bottomInset: CGFloat = 55.0
        }
        
    }
    private enum Default {
        
        static let text: String = "이 사진을 스팟! 할까요?"
        static let subText: String = "확정된 스팟은 변경할 수 없으며 \n 삭제만 가능합니다."
        
    }
    
    // MARK: - Properties
    
    public weak var navigationDelegate: SpotNavigationDelegate?
    private let viewModel: SpotSaveViewModel
    
    public var image: UIImage? {
        didSet {
            self.configureImageViewState()
        }
    }
    
    // MARK: - UI Components
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .msColor(.musicSpot)
        return imageView
    }()
    private let textView = UIView()
    private let textLabel = UILabel()
    private let subTextLabel = UILabel()
    private let cancelButton = MSRectButton.large(isBrandColored: false)
    private let completeButton = MSRectButton.large()
    
    // MARK: - Initializer
    
    public init(viewModel: SpotSaveViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    
    // MARK: - Life Cycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    // MARK: - Configure
    
    private func configure() {
        self.configureLayout()
        self.configureStyles()
        self.configureAction()
        self.configureState()
    }

    // MARK: - UI Components: Layout
    
    private func configureLayout() {
        self.configureImageViewLayout()
        self.configureTextViewLayout()
        self.configureLabelsLayout()
        self.configureButtonsLayout()
    }
    
    private func configureImageViewLayout() {
        self.view.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageView.heightAnchor.constraint(equalToConstant: Metric.ImageView.height),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureTextViewLayout() {
        self.view.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureLabelsLayout() {
        let labels: [UILabel] = [self.textLabel, self.subTextLabel]
        labels.forEach { label in
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            self.textLabel.heightAnchor.constraint(equalToConstant: Metric.TextLabel.height),
            self.subTextLabel.heightAnchor.constraint(equalToConstant: Metric.SubTextLabel.height),
            
            self.textLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor,
                                                constant: Metric.TextLabel.topInset),
            self.subTextLabel.topAnchor.constraint(equalTo: self.textLabel.bottomAnchor,
                                                   constant: Metric.SubTextLabel.topInset)
        ])
        self.subTextLabel.textAlignment = .center
    }
    
    private func configureButtonsLayout() {
        let buttons: [MSRectButton] = [self.cancelButton, self.completeButton]
        buttons.forEach { button in
            self.view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: Metric.Button.height),
                button.widthAnchor.constraint(equalToConstant: Metric.Button.width),
                button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                               constant: -Metric.Button.bottomInset)
            ])
        }
        NSLayoutConstraint.activate([
            self.cancelButton.trailingAnchor.constraint(equalTo: self.view.centerXAnchor,
                                                        constant: -Metric.Button.insetFromCenterX),
            self.completeButton.leadingAnchor.constraint(equalTo: self.view.centerXAnchor,
                                                         constant: Metric.Button.insetFromCenterX)
        ])
    }
    
    // MARK: - UI Components: Style
    
    private func configureStyles() {
        self.view.backgroundColor = .msColor(.primaryBackground)
        self.configureLabelsStyle()
        self.configureButtonsStyle()
    }
    
    private func configureLabelsStyle() {
        self.textLabel.font = .msFont(.subtitle)
        self.subTextLabel.font = .msFont(.caption)
        self.subTextLabel.textColor = .msColor(.secondaryTypo)
    }
    
    private func configureButtonsStyle() {
        self.cancelButton.image = .msIcon(.close)
        self.completeButton.image = .msIcon(.check)
    }
    
    // MARK: - Configure: Action
    
    private func configureAction() {
        self.configureCancelAction()
        self.configureCompleteAction()
    }
    
    private func configureCancelAction() {
        let cancelButtonAction = UIAction { [weak self] _ in
            self?.cancelButtonDidTap()
        }
        self.cancelButton.addAction(cancelButtonAction, for: .touchUpInside)
    }
    
    private func configureCompleteAction() {
        let completeButtonAction = UIAction { [weak self] _ in
            self?.completeButtonDidTap()
        }
        self.completeButton.addAction(completeButtonAction, for: .touchUpInside)
    }
    
    // MARK: - Configure: State
    
    private func configureState() {
        self.configureImageViewState()
        self.configureLabelsState()
    }
    
    private func configureImageViewState() {
        self.imageView.image = self.image
    }
    
    private func configureLabelsState() {
        self.textLabel.text = Default.text
        self.subTextLabel.text = Default.subText
        
        let multiLineConstant = 0
        self.subTextLabel.numberOfLines = multiLineConstant
    }
    
    // MARK: - Button Actions
    
    private func cancelButtonDidTap() {
        self.navigationDelegate?.dismissToSpot()
    }
    
    private func completeButtonDidTap() {
        guard let data = self.image?.pngData() else {
            MSLogger.make(category: .spot).debug("현재 이미지를 Data로 변환할 수 없습니다.")
            return
        }
        self.viewModel.trigger(.startUploadSpot, using: data)
        self.navigationDelegate?.popToHome()
    }
    
}

// MARK: - Preview
//
//@available(iOS 17, *)
//#Preview {
//    let spotView = SpotSaveViewController()
//    return spotView
//}
