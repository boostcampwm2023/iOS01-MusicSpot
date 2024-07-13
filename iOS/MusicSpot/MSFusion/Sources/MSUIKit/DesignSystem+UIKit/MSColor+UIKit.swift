//
//  MSColor+UIKit.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import UIKit

import MSDesignSystem

extension UIColor {
    public static func msColor(_ color: MSColor) -> UIColor {
        return UIColor(named: color.rawValue, in: .msDesignSystem, compatibleWith: .current)!
    }
}
