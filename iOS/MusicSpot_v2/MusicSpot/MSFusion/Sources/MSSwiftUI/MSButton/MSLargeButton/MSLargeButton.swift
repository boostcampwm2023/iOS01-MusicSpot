//
//  MSLargeButton.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/15/24.
//

import SwiftUI

import MSExtension

@MainActor
public struct MSLargeButton<ColorStyle: ColorSet>: View {
    
    // MARK: - Constants
    
    private enum Metric {
        static var imagePadding: CGFloat { 8.0 }
    }
    
    // MARK: - Properties
    
    internal let title: String
    internal let image: Image?
    internal let cornerStyle: MSLargeButtonStyle.CornerStyle
    internal let colorStyle: ColorStyle
    internal let action: () -> Void
    
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
            MSLargeButtonStyle(
                cornerStyle: self.cornerStyle,
                colorStyle: self.colorStyle
            )
        )
    }
    
}
