//
//  MSRectButtonModifier.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/22/24.
//

import SwiftUI

struct MSRectButtonModifier: ViewModifier {

    // MARK: Lifecycle

    // MARK: - Initializer

    init(isPressed: Bool, scale: MSRectButtonScale, colorStyle: SecondaryColors) {
        self.isPressed = isPressed
        self.scale = scale
        self.colorStyle = colorStyle
    }

    // MARK: Internal

    // MARK: - Body

    func body(content: Content) -> some View {
        content
            .frame(width: scale.imageSize.width, height: scale.imageSize.height)
            .padding(scale.padding)
            .background(
                colorStyle.backgroundColor.opacity(
                    isPressed ? 0.5 : 1.0))
            .foregroundStyle(colorStyle.foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: scale.cornerRadius))
            .scaleEffect(isPressed ? Metric.scaleRatio : 1.0)
            .shadow(
                color: colorStyle.foregroundColor.opacity(0.3),
                radius: 2.5, x: .zero, y: 2.0)
            .sensoryFeedback(.impact, trigger: isPressed) { oldValue, _ in
                oldValue == false
            }
    }

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static let scaleRatio: CGFloat = 0.94
    }

    // MARK: - Properties

    private let isPressed: Bool
    private let scale: MSRectButtonScale
    private let colorStyle: SecondaryColors

}
