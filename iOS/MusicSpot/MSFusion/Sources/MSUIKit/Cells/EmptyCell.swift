//
//  EmptyCell.swift
//  MSUIKit
//
//  Created by 이창준 on 2023.12.09.
//

import UIKit

public final class EmptyCell: UICollectionViewCell {

    // MARK: Lifecycle

    // MARK: - Initializer

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureStyles()
    }

    public required init?(coder _: NSCoder) {
        fatalError("MusicSpot은 code-based로만 작업 중입니다.")
    }

    // MARK: Private

    // MARK: - UI Configuration

    private func configureStyles() {
        backgroundColor = .clear
    }
}
