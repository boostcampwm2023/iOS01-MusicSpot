//
//  MSButton.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/15/24.
//

import SwiftUI

import MSExtension

@MainActor
public struct MSButton<ColorStyle: ColorSet>: View {
    
    // MARK: - Constants
    
    private enum Metric {
        static var imagePadding: CGFloat { 8.0 }
    }
    
    // MARK: - Properties
    
    internal let title: String
    internal let image: Image?
    internal let cornerStyle: MSButtonStyle.CornerStyle
    internal let colorStyle: ColorStyle
    internal let action: () -> Void
    
    // MARK: - Initializer
    
    public init(
        title: String = "",
        image: Image? = nil,
        cornerStyle: MSButtonStyle.CornerStyle = .squared,
        colorStyle: ColorStyle,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.cornerStyle = cornerStyle
        self.colorStyle = colorStyle
        self.action = action
    }
    
    // MARK: - Body
    
    public var body: some View {
        Button {
            self.action()
        } label: {
            HStack(spacing: Metric.imagePadding) {
                if let image = self.image {
                    image
                }
                
                if self.title.isNotEmpty {
                    Text(self.title)
                }
            }
        }
        .buttonStyle(
            MSButtonStyle(
                cornerStyle: self.cornerStyle,
                colorStyle: self.colorStyle
            )
        )
    }
    
}
