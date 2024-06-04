//
//  MSFont+UIKit.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import UIKit

import MSDesignSystem

extension MSFont {
    fileprivate func font() -> UIFont? {
        let details = self.fontDetails
        return UIFont(name: details.fontName, size: details.size)
    }
}

public extension UIFont {
    static func msFont(_ font: MSFont) -> UIFont? {
        return font.font()
    }
}
