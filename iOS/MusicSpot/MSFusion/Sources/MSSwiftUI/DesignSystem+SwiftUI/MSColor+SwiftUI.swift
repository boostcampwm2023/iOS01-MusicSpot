//
//  MSColor+SwiftUI.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import SwiftUI

import MSDesignSystem

extension Color {
    public static func msColor(_ color: MSColor) -> Color {
        Color(color.rawValue, bundle: .msDesignSystem)
    }
}
