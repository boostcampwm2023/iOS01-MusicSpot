//
//  MSRectButton.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/21/24.
//

import SwiftUI

// MARK: - MSRectButton

public struct MSRectButton<Style: MSRectButtonStyle>: View {

    // MARK: Lifecycle

    // MARK: - Initializer

    init(
        title: String = "",
        image: Image? = nil,
        style: Style,
        action: @escaping () -> Void)
    {
        self.title = title
        self.image = image
        self.style = style
        self.action = action
    }

    // MARK: Public

    // MARK: - Body

    public var body: some View {
        Button {
            action()
        } label: {
            HStack {
                if title.isNotEmpty {
                    Text(title)
                        .fixedSize()
                }
                image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .buttonStyle(style)
    }

    // MARK: Internal

    // MARK: - Properties

    let title: String
    let image: Image?
    let action: () -> Void
    let style: Style

}

#if targetEnvironment(simulator)
import MSDesignSystem
#Preview {
    MSFont.registerFonts()

    return VStack(spacing: 50) {
        HStack(spacing: 20.0) {
            MSRectPrimaryButton(title: "스팟!", colorStyle: .brand) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
            MSRectPrimaryButton(title: "스팟!", colorStyle: .default) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
        }

        HStack(spacing: 20.0) {
            MSRectPrimaryButton(image: .msIcon(.location), colorStyle: .brand) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
            MSRectPrimaryButton(image: .msIcon(.location), colorStyle: .default) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
        }

        HStack(spacing: 20.0) {
            MSRectSecondaryButton(image: .msIcon(.location), colorStyle: .brand) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
            MSRectSecondaryButton(image: .msIcon(.location), colorStyle: .default) {
                print("Hi") // swiftlint:disable:this no_direct_standard_out_logs
            }
        }
    }
}
#endif
