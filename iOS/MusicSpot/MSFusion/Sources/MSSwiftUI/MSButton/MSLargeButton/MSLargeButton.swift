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

    // MARK: Public

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: Metric.imagePadding) {
                if let image {
                    image
                }

                if title.isNotEmpty {
                    Text(title)
                }
            }
        }
        .buttonStyle(
            MSLargeButtonStyle(
                cornerStyle: cornerStyle,
                colorStyle: colorStyle))
    }

    // MARK: Internal

    // MARK: - Properties

    let title: String
    let image: Image?
    let cornerStyle: MSLargeButtonStyle.CornerStyle
    let colorStyle: ColorStyle
    let action: () -> Void

    // MARK: Private

    // MARK: - Constants

    private enum Metric {
        static var imagePadding: CGFloat { 8.0 }
    }

}
