//
//  MSGradientLayer.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.11.
//

import UIKit

public class MSGradientLayer: CAGradientLayer {
    // MARK: - Properties

    public var gradientColors: [UIColor] = [] {
        didSet { self.updateColors() }
    }

    // MARK: - Functions

    // swiftlint:disable identifier_name
    public override func hitTest(_ p: CGPoint) -> CALayer? {
        return nil
    }
    // swiftlint:enable identifier_name

    private func updateColors() {
        self.colors = self.gradientColors.map { $0.cgColor }
    }
}
