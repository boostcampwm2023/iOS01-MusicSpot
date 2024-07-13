//
//  MSRectButtonScale.swift
//  MSSwiftUI
//
//  Created by 이창준 on 4/20/24.
//

import CoreGraphics

public enum MSRectButtonScale {
    case small
    case large

    // MARK: Internal

    var imageSize: CGSize {
        switch self {
        case .small:
            CGSize(width: 24.0, height: 24.0)
        case .large:
            CGSize(width: 27.0, height: 27.0)
        }
    }

    var padding: CGFloat {
        switch self {
        case .small:
            10.0
        case .large:
            42.0
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .small:
            8.0
        case .large:
            30.0
        }
    }
}
