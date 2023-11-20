//
//  MSColor.swift
//  MSUIKit
//
//  Created by 이창준 on 11/19/23.
//

import UIKit

public enum MSColor: String {
    case primaryBackground = "Background Primary"
    case secondaryBackground = "Background Secondary"
    case primaryButtonBackground = "Button Background Primary"
    case secondaryButtonBackground = "Button Background Secondary"
    
    case primaryTypo = "Typo Primary"
    case primaryButtonTypo = "Button Typo Primary"
    case secondaryTypo = "Typo Secondary"
    case secondaryButtonTypo = "Button Typo Secondary"
    
    case musicSpot = "MusicSpot"
}

extension UIColor {
    
    public static func msColor(_ color: MSColor) -> UIColor {
        return UIColor(named: color.rawValue, in: .module, compatibleWith: .current)!
    }
    
}
