//
//  SettingViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func navigateToHomeMap()
}

class SettingViewController: UIViewController {

    var delegate: SettingViewControllerDelegate?

    var label: UILabel = {
        var label = UILabel()
        label.text = "Setting"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.view.addSubview(label)
    }

    @objc
    func navigateToHomeMap() {
        self.delegate?.navigateToHomeMap()
    }
    
}
