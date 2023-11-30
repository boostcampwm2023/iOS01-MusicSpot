//
//  SpotViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SpotViewControllerDelegate: AnyObject {
    func goHomeMap()
    func goSearchMusic()
}

class SpotViewController: UIViewController {

    // MARK: - Properties

    var delegate: SpotViewControllerDelegate?

    var number = 0

    lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "\(number)"
        return label
    }()

    var startButton: UIButton = {
        let button = UIButton()

        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .orange

        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        configureStyle()
        configureLayout()
    }

    // MARK: - Functions

    private func configureStyle() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(startButton)

        self.startButton.addTarget(self, action: #selector(navigateToHomeMap), for: .touchUpInside)
    }

    private func configureLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            startButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            startButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            startButton.heightAnchor.constraint(equalToConstant: 50),

            titleLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc
    func navigateToHomeMap() {
        self.delegate?.goHomeMap()
    }

    @objc
    func navigateToSearchMusic() {
        self.delegate?.goSearchMusic()
    }
}
