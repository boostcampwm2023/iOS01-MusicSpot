//
//  MSLargeButtonStyle.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public struct MSLargeButtonStyle: ButtonStyle {
    
    // MARK: - Constants
    
    public enum Metric {
        public static let height: CGFloat = 60.0
        fileprivate static let horizontalEdgeInsets: CGFloat = 58.0
        fileprivate static let scaleRatio: CGFloat = 0.94
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
                self.colorStyle.backgroundColor.opacity(
                    configuration.isPressed ? 0.5 : 1.0
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: self.cornerStyle.cornerRadius))
            .foregroundStyle(self.colorStyle.foregroundColor)
            .scaleEffect(configuration.isPressed ? Metric.scaleRatio : 1.0)
            .sensoryFeedback(.impact, trigger: configuration.isPressed) {
                oldValue, newValue in
                oldValue == false
            }
    }
    
}
