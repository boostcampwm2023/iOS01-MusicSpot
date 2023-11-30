//
//  HomeMapViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol HomeMapViewControllerDelegate: AnyObject {
    func navigateToSpot()
    func navigateToSearchMusic()
    func navigateToRewind()
    func navigateToSetting()
}

class HomeMapViewController: UIViewController {

    // MARK: - Properties

    var delegate: HomeMapViewControllerDelegate?

    var titleLabel: UILabel = {
        var label = UILabel()

        label.text = "HomeMap"

        return label
    }()

    var startButton: UIButton = {
        let button = UIButton()

        button.setTitle("시작하기", for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .gray

        return button
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.configureStyle()
        self.configureLayout()
    }

    // MARK: - Functions

    private func configureStyle() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(startButton)

        self.startButton.addTarget(self, action: #selector(navigateToSpot), for: .touchUpInside)
    }

    private func configureLayout() {

        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.startButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            self.startButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            self.startButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            self.startButton.heightAnchor.constraint(equalToConstant: 50),

            self.titleLabel.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 40),
            self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc
    func navigateToSpot() {
        self.delegate?.navigateToSpot()
    }

    @objc
    func navigateToRewind() {
        self.delegate?.navigateToRewind()
    }

    @objc
    func navigateToSetting() {
        self.delegate?.navigateToSetting()
    }
    
}
