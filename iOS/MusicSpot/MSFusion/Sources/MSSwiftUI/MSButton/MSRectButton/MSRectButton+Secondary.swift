//
//  MSRectButton+Secondary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/21/24.
//

import SwiftUI

public typealias MSRectSecondaryButton = MSRectButton<MSRectSecondaryButtonStyle>

extension MSRectSecondaryButton {
    public init(
        image: Image?,
        colorStyle: SecondaryColors = .default,
        action: @escaping () -> Void)
    {
        self.init(
            title: "",
            image: image,
            style: MSRectSecondaryButtonStyle(colorStyle: colorStyle, scale: .small),
            action: action)
    }
}

// MARK: - MSRectSecondaryButtonStyle

public struct MSRectSecondaryButtonStyle: MSRectButtonStyle {
    // MARK: - Properties

    public var colorStyle: SecondaryColors
    public var scale: MSRectButtonScale

    // MARK: - Body

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(
                MSRectButtonModifier(
                    isPressed: configuration.isPressed,
                    scale: scale,
                    colorStyle: colorStyle))
    }
}
