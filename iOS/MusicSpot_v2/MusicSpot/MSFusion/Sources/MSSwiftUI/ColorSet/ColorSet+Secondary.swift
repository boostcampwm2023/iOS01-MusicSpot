//
//  ColorSet+Secondary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public enum SecondaryColors: ColorSet {
    case `default`
    case brand
    
    public var backgroundColor: Color {
        switch self {
        case .default:
            return .msColor(.secondaryButtonBackground)
        case .brand:
            return .msColor(.musicSpot)
        }
    }
    
    public var foregroundColor: Color {
        return .msColor(.secondaryButtonTypo)
    }
    
}
