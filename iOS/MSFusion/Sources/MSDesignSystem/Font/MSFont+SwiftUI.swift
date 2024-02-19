//
//  MSFont+SwiftUI.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

extension MSFont {
    
    fileprivate func font() -> Font? {
        let details = self.fontDetails
        return Font.custom(details.fontName, size: details.size)
    }
    
}

public extension Font {
    
    static func msFont(_ font: MSFont) -> Font? {
        return font.font()
    }
    
}
