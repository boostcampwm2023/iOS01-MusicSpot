//
//  MSRectButtonModifier.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/22/24.
//

import SwiftUI

internal struct MSRectButtonModifier: ViewModifier {
    
    // MARK: - Constants
    
    private enum Metric {
        static let scaleRatio: CGFloat = 0.94
    }
    
    // MARK: - Properties
    
    private let isPressed: Bool
    private let scale: MSRectButtonScale
    private let colorStyle: SecondaryColors
    
    // MARK: - Initializer
    
    internal init(isPressed: Bool, scale: MSRectButtonScale, colorStyle: SecondaryColors) {
        self.isPressed = isPressed
        self.scale = scale
        self.colorStyle = colorStyle
    }
    
    // MARK: - Body
    
    internal func body(content: Content) -> some View {
        content
            .frame(width: self.scale.imageSize.width, height: self.scale.imageSize.height)
            .padding(self.scale.padding)
            .background(
                self.colorStyle.backgroundColor.opacity(
                    self.isPressed ? 0.5 : 1.0
                )
            )
            .foregroundStyle(self.colorStyle.foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: self.scale.cornerRadius))
            .scaleEffect(self.isPressed ? Metric.scaleRatio : 1.0)
            .shadow(
                color: self.colorStyle.foregroundColor.opacity(0.3),
                radius: 2.5, x: .zero, y: 2.0
            )
            .sensoryFeedback(.impact, trigger: self.isPressed) {
                oldValue, newValue in
                oldValue == false
            }
    }
    
}
