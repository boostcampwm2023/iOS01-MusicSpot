//
//  MSButton+Secondary.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

import MSDesignSystem

extension MSButton {
    public static func secondary() -> MSButton {
        let button = MSButton()
        button.configuration?.baseForegroundColor = .msColor(.secondaryButtonTypo)
        button.configuration?.baseBackgroundColor = .msColor(.secondaryButtonBackground)
        return button
    }
}
