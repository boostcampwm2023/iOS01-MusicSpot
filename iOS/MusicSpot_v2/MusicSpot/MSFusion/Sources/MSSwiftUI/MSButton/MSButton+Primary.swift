//
//  File.swift
//  
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public typealias MSPrimaryButton = MSButton<Primary>

extension MSPrimaryButton {
    
    public init(
        title: String = "",
        image: Image? = nil,
        cornerStyle: MSButtonStyle.CornerStyle = .squared,
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
