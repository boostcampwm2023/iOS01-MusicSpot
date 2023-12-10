//
//  MSButton+Primary.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

extension MSButton {
    
    public static func primary(isBrandColored: Bool = true) -> MSButton {
        let button = MSButton()
        button.configuration?.baseForegroundColor = .msColor(.primaryButtonTypo)
        button.configuration?.baseBackgroundColor = isBrandColored
        ? .msColor(.musicSpot)
        : .msColor(.primaryButtonBackground)
        return button
    }
    
}
