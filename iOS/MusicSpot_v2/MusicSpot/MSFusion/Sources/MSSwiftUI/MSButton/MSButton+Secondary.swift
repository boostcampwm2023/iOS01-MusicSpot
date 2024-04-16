//
//  MSButton+Secondary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.20.
//

import SwiftUI

public typealias MSSecondaryButton = MSButton<Secondary>

extension MSSecondaryButton {
    
    public init(
        title: String = "",
        image: Image? = nil,
        cornerStyle: MSButtonStyle.CornerStyle = .squared,
        colorStyle: ColorStyle = .default,
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
    return MSSecondaryButton(
        title: "재생",
        image: .msIcon(.play),
        cornerStyle: .rounded
    ) {
        print("Play")
    }
}
#endif
