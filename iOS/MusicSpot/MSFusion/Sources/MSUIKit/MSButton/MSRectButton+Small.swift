//
//  MSRectButton+Small.swift
//  MSUIKit
//
//  Created by 이창준 on 11/20/23.
//

import MSDesignSystem

extension MSRectButton {
    public static func small(isBrandColored: Bool = false) -> MSRectButton {
        let button = MSRectButton()
        button.style = .small
        button.configuration?.baseBackgroundColor = isBrandColored
        ? .msColor(.musicSpot)
        : .msColor(.secondaryButtonBackground).withAlphaComponent(0.8)
        return button
    }
}
