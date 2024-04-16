//
//  ColorSet+Secondary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public enum Secondary: ColorSet {
    case `default`
    
    public var backgroundColor: Color {
        switch self {
        case .default:
            return .msColor(.primaryButtonBackground)
        }
    }
    
    public var foregroundColor: Color {
        return .msColor(.secondaryButtonTypo)
    }
    
}

