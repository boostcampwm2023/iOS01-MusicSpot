//
//  TestView.swift
//  MusicSpot
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

final class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .msColor(.primaryBackground)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        stackView.addArrangedSubview(makeLabel(.superTitle, text: "Super Title_34_Bold"))
        stackView.addArrangedSubview(makeLabel(.duperTitle, text: "Duper Title_28_Bold"))
        stackView.addArrangedSubview(makeLabel(.headerTitle, text: "Header Title_22_Bold"))
        stackView.addArrangedSubview(makeLabel(.subtitle, text: "Subtitle_20_Bold"))
        stackView.addArrangedSubview(makeLabel(.buttonTitle, text: "Button_20_SemiBold"))
        stackView.addArrangedSubview(makeLabel(.paragraph, text: "Paragraph_17_Regular"))
        stackView.addArrangedSubview(makeLabel(.caption, text: "Caption_13_Regular"))
    }
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func makeLabel(_ font: MSFont, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .msFont(font)
        label.textColor = .msColor(.musicSpot)
        label.text = text
        return label
    }
}

@available(iOS 17.0, *)
#Preview {
    MSFont.registerFonts()
    let testVC = TestViewController()
    return testVC
}
