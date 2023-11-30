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

/// HomeMap 내의 버튼들을 감싸는 View
final class NavigateMapButtonView: UIView {
    
    // MARK: - Properties
    
    private var buttonStackView: ButtonStackView = {
        let view = ButtonStackView()
        return view
    }()
    
    // Button별 기능 주입
    var settingButtonAction: (() -> Void)? {
        didSet {
            buttonStackView.settingButtonAction = settingButtonAction
        }
    }
    
    var mapButtonAction: (() -> Void)? {
        didSet {
            buttonStackView.mapButtonAction = mapButtonAction
        }
    }
    
    var locationButtonAction: (() -> Void)? {
        didSet {
            buttonStackView.locationButtonAction = locationButtonAction
        }
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyle()
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
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
    
}

/// HomeMap 내 3개 버튼 StackView
class ButtonStackView: UIStackView {
    
    // MARK: - Properties
    
    var settingButtonAction: (() -> Void)?
    var mapButtonAction: (() -> Void)?
    var locationButtonAction: (() -> Void)?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Functions
    
    private func configureLayout() {
        axis = .vertical
        spacing = 24
        alignment = .fill
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
        
        let settingButton = self.createButton(image: ButtonImage.setting)
        settingButton.addTarget(self, action: #selector(settingButtondidTap), for: .touchUpInside)
        let mapButton = self.createButton(image: ButtonImage.map)
        mapButton.addTarget(self, action: #selector(mapButtondidTap), for: .touchUpInside)
        let locationButton = self.createButton(image: ButtonImage.location)
        locationButton.addTarget(self, action: #selector(locationButtondidTap), for: .touchUpInside)
        
        addArrangedSubview(settingButton)
        addArrangedSubview(mapButton)
        addArrangedSubview(locationButton)
    }
    
    private func createButton(image: ButtonImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            let symbolImage = UIImage(systemName: image.rawValue)
            button.setImage(symbolImage, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        button.imageView?.tintColor = .black
        
        button.layer.borderColor = UIColor.black.cgColor
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    // MARK: - Object Functions
    
    @objc private func settingButtondidTap() {
        settingButtonAction?()
    }
    
    @objc private func mapButtondidTap() {
        mapButtonAction?()
    }
    
    @objc private func locationButtondidTap() {
        locationButtonAction?()
    }
    
}
