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
            .msColor(.secondaryButtonBackground)
        case .brand:
            .msColor(.musicSpot)
        }
    }

    public var foregroundColor: Color {
        .msColor(.secondaryButtonTypo)
    }
}
