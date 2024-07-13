//
//  MSIcon+SwiftUI.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

import MSDesignSystem

extension Image {
    public static func msIcon(_ icon: MSIcon) -> Image? {
        return Image(icon.rawValue, bundle: .msDesignSystem)
            .renderingMode(.template)
    }
}
