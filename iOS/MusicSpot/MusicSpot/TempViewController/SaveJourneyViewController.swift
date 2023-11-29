//
//  RewindViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/29/23.
//

import UIKit

protocol SaveJourneyViewControllerDelegate {
    func goHomeMap()
    func goSearchMusic()
}

class SaveJourneyViewController: UIViewController {
    
    var delegate: SaveJourneyViewControllerDelegate?

    var label: UILabel = {
        var label = UILabel()
        label.text = "SaveJourney"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(label)
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
