//
//  MSRectButton+Primary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/21/24.
//

import SwiftUI

public typealias MSRectPrimaryButton = MSRectButton<MSRectPrimaryButtonStyle>

extension MSRectPrimaryButton {
    // MARK: - Initializer

    public init(
        title: String = "",
        image: Image? = nil,
        colorStyle: SecondaryColors,
        action: @escaping () -> Void)
    {
        self.init(
            title: title,
            image: image,
            style: MSRectPrimaryButtonStyle(colorStyle: colorStyle, scale: .large),
            action: action)
    }
}

// MARK: - MSRectPrimaryButtonStyle

public struct MSRectPrimaryButtonStyle: MSRectButtonStyle {
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
            .font(.msFont(.buttonTitle))
    }
}
