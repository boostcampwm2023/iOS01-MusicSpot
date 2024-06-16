//
//  MSRectButton.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/21/24.
//

import SwiftUI

public struct MSRectButton<Style: MSRectButtonStyle>: View {
    // MARK: - Properties

    internal let title: String
    internal let image: Image?
    internal let action: () -> Void
    internal let style: Style

    // MARK: - Initializer

    internal init(
        title: String = "",
        image: Image? = nil,
        style: Style,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.style = style
        self.action = action
    }

    // MARK: - Body

    public var body: some View {
        Button {
            self.action()
        } label: {
            HStack {
                if self.title.isNotEmpty {
                    Text(self.title)
                        .fixedSize()
                }
                self.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .buttonStyle(self.style)
    }
}

#if targetEnvironment(simulator)
import MSDesignSystem
#Preview {
    MSFont.registerFonts()

    return VStack(spacing: 50) {
        HStack(spacing: 20.0) {
            MSRectPrimaryButton(title: "스팟!", colorStyle: .brand) {
                print("Hi")
            }
            MSRectPrimaryButton(title: "스팟!", colorStyle: .default) {
                print("Hi")
            }
        }

        HStack(spacing: 20.0) {
            MSRectPrimaryButton(image: .msIcon(.location), colorStyle: .brand) {
                print("Hi")
            }
            MSRectPrimaryButton(image: .msIcon(.location), colorStyle: .default) {
                print("Hi")
            }
        }

        HStack(spacing: 20.0) {
            MSRectSecondaryButton(image: .msIcon(.location), colorStyle: .brand) {
                print("Hi")
            }
            MSRectSecondaryButton(image: .msIcon(.location), colorStyle: .default) {
                print("Hi")
            }
        }
    }
}
#endif
