//
//  JourneyListBackgroundView.swift
//  JourneyList
//
//  Created by 이창준 on 11/23/23.
//

import UIKit

import MSDesignSystem

public final class JourneyListBackgroundView: UICollectionReusableView {
    
    // MARK: - Constants
    
    public static let reuseIdentifier = "JourneyListBackgroundView"
    
    private enum Metric {
        static let cornerRadius: CGFloat = 12.0
    }
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
}

private extension JourneyListBackgroundView {
    
    func configureStyle() {
        self.backgroundColor = .msColor(.componentBackground)
        self.layer.cornerRadius = Metric.cornerRadius
        self.clipsToBounds = true
    }
    
}
