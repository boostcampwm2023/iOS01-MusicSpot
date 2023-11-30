//
//  RewindViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol SaveJourneyViewControllerDelegate: AnyObject {
    func navigateToHomeMap()
    func navigateToSearchMusic()
}

class SaveJourneyViewController: UIViewController {

    // MARK: - Properties

    var delegate: SaveJourneyViewControllerDelegate?

    var label: UILabel = {
        var label = UILabel()
        label.text = "SaveJourney"
        return label
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(label)
    }

    // MARK: - Functions

    @objc
    func navigateToHomeMap() {
        self.delegate?.navigateToHomeMap()
    }

    @objc
    func navigateToSearchMusic() {
        self.delegate?.navigateToSearchMusic()
    }
    
}
