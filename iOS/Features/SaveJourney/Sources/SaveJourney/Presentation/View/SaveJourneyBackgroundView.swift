//
//  SaveJourneyBackgroundView.swift
//  SaveJourney
//
//  Created by 이창준 on 11/24/23.
//

import UIKit

import MSDesignSystem

final class SaveJourneyBackgroundView: UICollectionReusableView {
    
    // MARK: - Constants
    
    static let elementKind = "SaveJourneyBackgroundView"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
}

// MARK: - UI Configuration

private extension SaveJourneyBackgroundView {
    
    func configureStyles() {
        self.backgroundColor = .msColor(.primaryBackground)
    }
    
}
