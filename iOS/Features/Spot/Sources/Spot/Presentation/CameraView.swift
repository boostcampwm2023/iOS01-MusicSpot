//
//  CameraView.swift
//  Spot
//
//  Created by 전민건 on 11/28/23.
//

import AVFoundation
import UIKit

import MSLogger

final class CameraView: UIView {
    
    private enum Metric {
        static let cornerRadius: CGFloat = 15.0
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
}

// MARK: - UI Configuration: Style

private extension CameraView {
    
    func configureStyle() {
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
}
