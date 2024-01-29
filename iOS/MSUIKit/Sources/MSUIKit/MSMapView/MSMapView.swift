//
//  MSMapView.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.29.
//

import UIKit

open class MSMapView: UIView {
    
    // MARK: - Constants
    
    private enum Metric {
        
        enum GradientLayer {
            static let alpha: Double = 0.7
            static let startingPoint: NSNumber = 0.55
            static let endPoint: NSNumber = 0.95
        }
        
    }
    
    // MARK: - UI Components
    
    private var mapView: MSMapRenderingView!
    
    private let gradientLayer: MSGradientLayer = {
        let gradientLayer = MSGradientLayer()
        gradientLayer.gradientColors = [
            .msColor(.primaryBackground).withAlphaComponent(.zero),
            .msColor(.primaryBackground).withAlphaComponent(Metric.GradientLayer.alpha)
        ]
        gradientLayer.locations = [
            Metric.GradientLayer.startingPoint,
            Metric.GradientLayer.endPoint
        ]
        return gradientLayer
    }()
    
    // MARK: - Initializer
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public convenience init(using provider: MapProvider) {
        self.init(frame: .zero)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - Life Cycle
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
}

// MARK: - Functions: Interface

extension MSMapView {
    
}
