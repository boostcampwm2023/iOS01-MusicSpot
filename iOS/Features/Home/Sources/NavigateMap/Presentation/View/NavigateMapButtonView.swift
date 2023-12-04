//
//  NavigateMapButtonView.swift
//  Home
//
//  Created by 윤동주 on 11/22/23.
//

import UIKit

enum ButtonImage: String {
    case setting = "gearshape.fill",
         map = "map.fill",
         location = "mappin"
}

protocol NavigateMapButtonViewDelegate: AnyObject {
    
    func settingButtonDidTap()
    func mapButtonDidTap()
    func locationButtonDidTap()
    
}

/// HomeMap 내의 버튼들을 감싸는 View
public final class NavigateMapButtonView: UIView {
    
    // MARK: - UI Components
    
    public var buttonStackView: ButtonStackView = {
        let view = ButtonStackView()
        return view
    }()
    
    // MARK: - Properties

    weak var delegate: NavigateMapButtonViewDelegate?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureStyle()
        self.configureLayout()
        self.configureAction()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyle() {
        backgroundColor = .lightGray
        layer.cornerRadius = 8
        
    }
    
    private func configureLayout() {
        addSubview(buttonStackView)
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configure: Action
    
    private func configureAction() {
        self.configureSettingButtonAction()
        self.configureMapButtonAction()
        self.configureLocationButtonAction()
    }
    
    
    private func configureSettingButtonAction() {
        let settingButtonAction = UIAction(handler: { _ in
            self.settingButtonDidTap()
        })
        self.buttonStackView.settingButton.addAction(settingButtonAction, for: .touchUpInside)
    }
    
    private func configureMapButtonAction() {
        let mapButtonAction = UIAction(handler: { _ in
            self.mapButtonDidTap()
        })
        self.buttonStackView.mapButton.addAction(mapButtonAction, for: .touchUpInside)
    }
    
    private func configureLocationButtonAction() {
        let locationButtonAction = UIAction(handler: { _ in
            self.locationButtonDidTap()
        })
        self.buttonStackView.locationButton.addAction(locationButtonAction, for: .touchUpInside)
    }
    
    // MARK: - Functions
    
    private func settingButtonDidTap() {
        delegate?.settingButtonDidTap()
    }
    
    private func mapButtonDidTap() {
        delegate?.mapButtonDidTap()
    }
    
    private func locationButtonDidTap() {
        delegate?.locationButtonDidTap()
    }
    
}

/// HomeMap 내 3개 버튼 StackView
final public class ButtonStackView: UIStackView {
    
    // MARK: - Properties

    private lazy var settingButton = self.createButton(image: ButtonImage.setting)
    
    private lazy var mapButton = self.createButton(image: ButtonImage.map)
    
    private lazy var locationButton = self.createButton(image: ButtonImage.location)
    
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureLayout() {
        
        self.addArrangedSubview(settingButton)
        self.addArrangedSubview(mapButton)
        self.addArrangedSubview(locationButton)
        
        self.axis = .vertical
        self.spacing = 24
        self.alignment = .fill
        self.distribution = .fillEqually
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Functions
    
    private func createButton(image: ButtonImage) -> UIButton {
        let button = UIButton()
        let buttonImage = UIImage(systemName: image.rawValue)
        
        button.setImage(buttonImage, for: .normal)
        
        return button
    }
    
}
