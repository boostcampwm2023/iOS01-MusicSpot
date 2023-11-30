//
//  RewindViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SearchMusicViewControllerDelegate: AnyObject {
    func goHomeMap()
    func goSaveJourney()
}

class SearchMusicViewController: UIViewController {

    var delegate: SearchMusicViewControllerDelegate?

    var label: UILabel = {
        var label = UILabel()
        label.text = "SearchMusic"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(label)
    }

    @objc
    func navigateToHomeMap() {
        self.delegate?.goHomeMap()
    }

    @objc
    func navigateToSaveJourney() {
        self.delegate?.goSaveJourney()
    }
    
}
