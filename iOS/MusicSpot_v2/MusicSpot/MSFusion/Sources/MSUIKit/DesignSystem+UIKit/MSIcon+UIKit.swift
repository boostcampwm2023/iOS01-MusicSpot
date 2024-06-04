//
//  MSIcon+UIKit.swift
//  MSDesignSystem
//
//  Created by 이창준 on 2024.02.19.
//

import UIKit

import MSDesignSystem

extension UIImage {
    public static func msIcon(_ icon: MSIcon) -> UIImage? {
        return UIImage(named: icon.rawValue, in: .msDesignSystem, compatibleWith: .current)?
            .withRenderingMode(.alwaysTemplate)
    }
}
