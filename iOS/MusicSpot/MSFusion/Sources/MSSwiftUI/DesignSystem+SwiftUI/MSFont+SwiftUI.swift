//
//  MSFont+SwiftUI.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

import MSDesignSystem

extension MSFont {
    fileprivate func font() -> Font? {
        let details = fontDetails
        return Font.custom(details.fontName, size: details.size)
    }
}

extension Font {
    public static func msFont(_ font: MSFont) -> Font? {
        font.font()
    }
}
