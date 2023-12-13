//
//  MapView.swift
//  Home
//
//  Created by 윤동주 on 11/28/23.
//

import Foundation
import UIKit
import MapKit

class MapView: UIView {
    
    // MARK: - Properties
    
    let centerbutton = UIButton()
    let map = MKMapView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(map)
        self.addSubview(centerbutton)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI Configuration
    
    func configureLayout() {
        
        centerbutton.setTitle("시작하기", for: .normal)
        centerbutton.backgroundColor = .darkGray
        centerbutton.setTitleColor(.yellow, for: .normal)
        centerbutton.layer.cornerRadius = 12
    }
    
}
