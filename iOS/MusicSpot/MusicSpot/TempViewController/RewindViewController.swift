//
//  RewindViewController.swift
//  MusicSpot
//
//  Created by 윤동주 on 11/28/23.
//

import UIKit

protocol RewindViewControllerDelegate: AnyObject {
    func goHomeMap()
}

class RewindViewController: UIViewController {

    var delegate: RewindViewControllerDelegate?

    var label: UILabel = {
        var label = UILabel()
        label.text = "Rewind"
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
    
}
