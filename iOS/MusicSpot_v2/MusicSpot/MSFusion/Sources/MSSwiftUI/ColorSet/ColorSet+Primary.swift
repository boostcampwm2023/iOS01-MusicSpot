//
//  ColorSet+Primary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public enum Primary: ColorSet {
    case brand
    case `default`
    
    public var backgroundColor: Color {
        switch self {
        case .brand:
            return .msColor(.musicSpot)
        case .default:
            return .msColor(.primaryButtonBackground)
        }
    }
    
    public var foregroundColor: Color {
        return .msColor(.primaryButtonTypo)
    }
    
}
