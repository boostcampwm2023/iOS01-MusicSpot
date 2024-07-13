//
//  MSGradientLayer.swift
//  MSUIKit
//
//  Created by 이창준 on 2024.01.11.
//

import UIKit

public class MSGradientLayer: CAGradientLayer {

    // MARK: Public

    // MARK: - Properties

    public var gradientColors: [UIColor] = [] {
        didSet { updateColors() }
    }

    // MARK: - Functions

    // swiftlint:disable identifier_name
    public override func hitTest(_: CGPoint) -> CALayer? {
        nil
    }

    // MARK: Private

    // swiftlint:enable identifier_name

    private func updateColors() {
        colors = gradientColors.map { $0.cgColor }
    }
}
