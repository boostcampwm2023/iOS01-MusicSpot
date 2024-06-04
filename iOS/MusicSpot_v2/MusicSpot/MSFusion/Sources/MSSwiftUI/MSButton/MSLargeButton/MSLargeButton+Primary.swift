//
//  MSLargeButton+Primary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public typealias MSPrimaryButton = MSLargeButton<PrimaryColors>

extension MSPrimaryButton {
    public init(
        title: String = "",
        image: Image? = nil,
        cornerStyle: MSLargeButtonStyle.CornerStyle = .squared,
        colorStyle: ColorStyle = .brand,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.image = image
        self.cornerStyle = cornerStyle
        self.colorStyle = colorStyle
        self.action = action
    }
}

#if targetEnvironment(simulator)
import MSDesignSystem

#Preview {
    MSFont.registerFonts()
    return MSPrimaryButton(
        title: "재생",
        image: .msIcon(.play),
        cornerStyle: .rounded
    ) {
        print("Play")
    }
}
#endif
