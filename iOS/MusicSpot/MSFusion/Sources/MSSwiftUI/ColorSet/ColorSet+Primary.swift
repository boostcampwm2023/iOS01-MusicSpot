//
//  ColorSet+Primary.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/16/24.
//

import SwiftUI

public enum PrimaryColors: ColorSet {
    case `default`
    case brand

    public var backgroundColor: Color {
        switch self {
        case .default:
            return .msColor(.primaryButtonBackground)
        case .brand:
            return .msColor(.musicSpot)
        }
    }

    public var foregroundColor: Color {
        return .msColor(.primaryButtonTypo)
    }
}