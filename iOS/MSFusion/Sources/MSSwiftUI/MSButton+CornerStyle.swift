//
//  MSButton+CornerStyle.swift
//  MSSwiftUI
//
//  Created by 이창준 on 2024.02.20.
//

import CoreGraphics

extension MSButton {
    
    public enum CornerStyle {
        case squared
        case rounded
        case custom(CGFloat)
        
        var cornerRadius: CGFloat {
            switch self {
            case .squared: return 8.0
            case .rounded: return 25.0
            case .custom(let cornerRadius): return cornerRadius
            }
        }
    }
    
}
