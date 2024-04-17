//
//  MSButtonStyle.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public struct MSButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    private enum Metric {
        static let height: CGFloat = 60.0
        static let horizontalEdgeInsets: CGFloat = 58.0
        static let scaleRatio: CGFloat = 0.87
    }
    
    // MARK: - Properties
    
    private let cornerStyle: CornerStyle
    private let colorStyle: ColorSet
    
    // MARK: - Initializer
    
    package init(
        cornerStyle: CornerStyle,
        colorStyle: ColorSet
    ) {
        self.cornerStyle = cornerStyle
        self.colorStyle = colorStyle
    }
    
    // MARK: - Body
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.msFont(.buttonTitle))
            .frame(height: Metric.height)
            .padding(.horizontal, Metric.horizontalEdgeInsets)
            .background(
                configuration.isPressed
                ? self.colorStyle.backgroundColor.opacity(0.5)
                : self.colorStyle.backgroundColor
            )
            .clipShape(RoundedRectangle(cornerRadius: self.cornerStyle.cornerRadius))
            .foregroundStyle(self.colorStyle.foregroundColor)
            .scaleEffect(configuration.isPressed ? Metric.scaleRatio : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .shadow(
                color: self.colorStyle.backgroundColor.opacity(0.3),
                radius: 10.0, x: .zero, y: 10.0
            )
    }
    
}
