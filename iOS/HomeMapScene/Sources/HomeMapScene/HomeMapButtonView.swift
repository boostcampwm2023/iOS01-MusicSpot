//
//  HomeMapButtonView.swift
//  Test
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
final class HomeMapButtonView: UIView {
    
    // MARK: - Properties

    private var buttonStackView: ButtonStackView = {
        let view = ButtonStackView()
        return view
    }()
    
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyle()
        configureLayout()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
        configureStyle()
        configureLayout()
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

    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayouts()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setLayouts()
    }
    // MARK: - Functions

    private func setLayouts() {
        axis = .vertical
        spacing = 24  // vertical spacing between buttons
        alignment = .fill
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false

        let settingButton = createButton(image: ButtonImage.setting)
        settingButton.addTarget(self, action: #selector(settingButtondidTap), for: .touchUpInside)
        
        let mapButton = createButton(image: ButtonImage.map)
        mapButton.addTarget(self, action: #selector(mapButtondidTap), for: .touchUpInside)
        
        let locationButton = createButton(image: ButtonImage.location)
        locationButton.addTarget(self, action: #selector(locationButtondidTap), for: .touchUpInside)
        
        addArrangedSubview(settingButton)
        addArrangedSubview(mapButton)
        addArrangedSubview(locationButton)
    }

    private func createButton(image: ButtonImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let symbolImage = UIImage(systemName: image.rawValue)
        button.setImage(symbolImage, for: .normal)
        button.imageView?.tintColor = .black
        
        button.layer.borderColor = UIColor.black.cgColor
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    // MARK: - Object Functions
    
    @objc private func settingButtondidTap() {
        dump("settingButton이 눌렸습니다.")
    }
    
    @objc private func mapButtondidTap() {
        dump("mapButton이 눌렸습니다.")
    }
    
    @objc private func locationButtondidTap() {
        dump("locationButton이 눌렸습니다.")
    }
}
