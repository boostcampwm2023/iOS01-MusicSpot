//
//  MSLargeButtonStyle+CornerStyle.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import CoreGraphics

extension MSLargeButtonStyle {
    public enum CornerStyle {
        case squared
        case rounded
        case custom(CGFloat)

        var cornerRadius: CGFloat {
            switch self {
            case .squared: 8.0
            case .rounded: 25.0
            case .custom(let cornerRadius): cornerRadius
            }
        }
    }
}
