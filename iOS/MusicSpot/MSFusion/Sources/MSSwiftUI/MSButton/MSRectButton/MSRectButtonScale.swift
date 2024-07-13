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

    internal var imageSize: CGSize {
        switch self {
        case .small:
            return CGSize(width: 24.0, height: 24.0)
        case .large:
            return CGSize(width: 27.0, height: 27.0)
        }
    }

    internal var padding: CGFloat {
        switch self {
        case .small:
            return 10.0
        case .large:
            return 42.0
        }
    }

    internal var cornerRadius: CGFloat {
        switch self {
        case .small:
            return 8.0
        case .large:
            return 30.0
        }
    }
}
