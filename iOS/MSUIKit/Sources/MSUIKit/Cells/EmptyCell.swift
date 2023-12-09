//
//  EmptyCell.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.09.
//

import UIKit

public final class EmptyCell: UICollectionViewCell {
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureStyles()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }
    
    // MARK: - UI Configuration
    
    private func configureStyles() {
        self.backgroundColor = .clear
    }
    
}
